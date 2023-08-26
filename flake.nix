{
  description = "raccoon's radicool flakey nix stuff";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    deploy-rs.url = "github:serokell/deploy-rs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, nur, deploy-rs, agenix
    , home-manager }:
    with nixpkgs.lib;
    let
      raccoonlib = (import ./lib) nixpkgs.lib;

      inherit (raccoonlib) forAllSystems;

      _specialArgs = forAllSystems (system: {
        inherit raccoonlib;
        raccoonpkgs = self.legacyPackages.${system};
      });

      hostFilesIn = path:
        let
          suffix = ".host.nix";

          mkHostFile = file: {
            path = path + ("/" + file);
            host = removeSuffix suffix file;
          };
          hostFileNames = filter (file: hasSuffix suffix file)
            (attrNames (builtins.readDir path));
        in map mkHostFile hostFileNames;

      nodes = let nodesConfig = import ./nodes.nix;
      in mapAttrs (_: v: nodesConfig.default // v) nodesConfig;

      getNode = name: nodes.${name} or nodes.default;
    in {

      ############################
      # Exports for External Use #
      ############################

      lib = raccoonlib;

      overlays.default = (import ./pkgs) self.lib;

      # regular old `packages` doesn't like sub-sets of packages
      legacyPackages = forAllSystems (system:
        let
          prev = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in (self.overlays.default { } prev).rac);

      #######################
      # NixOS Configuration #
      #######################

      nixosConfigurations = let
        mkHost = file:
          let node = getNode file.host;
          in nixpkgs.lib.nixosSystem (rec {
            inherit (node) system;

            modules = [
              agenix.nixosModules.age
              home-manager.nixosModules.home-manager
              ./nixos/modules
              ./nixos/profiles
              file.path
              {
                system.stateVersion = node.stateVersion;
                networking.hostName = file.host;

                nix = {
                  registry = mapAttrs
                    (name: v: { flake = v; })
                    (filterAttrs (name: v: v ? outputs) inputs);
                  settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
                };
              }
            ];

            specialArgs = _specialArgs.${system};
          });

        mkHostPair = file: nameValuePair file.host (mkHost file);
      in listToAttrs (map mkHostPair (hostFilesIn ./nixos/profiles));

      ##############################
      # Home Manager Configuration #
      ##############################

      homeConfigurations = let
        dirsIn = path:
          attrNames
          (filterAttrs (_: type: type == "directory") (builtins.readDir path));
        userDirs = dirsIn ./home;

        userDirHostFiles = username:
          map (file: { inherit username file; })
          (hostFilesIn (./home + "/${username}/profiles"));

        userDirsHostFiles = flatten (map userDirHostFiles userDirs);

        mkHomeConfiguration = { username, file }:
          let node = getNode file.host;
          in home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${node.system};

            extraSpecialArgs = _specialArgs.${node.system};

            modules = [
              (./home + "/${username}/modules")
              (./home + "/${username}/profiles")
              file.path
              {
                home = {
                  inherit (node) stateVersion;
                  inherit username;
                  homeDirectory = "/home/${username}";
                };
                nixpkgs = {
                  config = { inherit (host) allowUnfree; };

                  overlays = [
                    nur.overlay
                    agenix.overlays.default
                    self.overlays.default
                    (final: prev: {
                      inherit (unstable) # ...
                      ;
                    })
                  ];
                };
              }
            ];
          };

        mkHomeConfigurationPair = hostFile@{ username, file }:
          nameValuePair (username + "@" + file.host)
          (mkHomeConfiguration hostFile);
      in listToAttrs (map mkHomeConfigurationPair userDirsHostFiles);

      ###########################
      # deploy-rs Configuration #
      ###########################

      deploy.nodes = let
        mkAuthority = authority:
          let splitAuthority = splitString "@" authority;
          in {
            inherit authority;
            user = head splitAuthority;
            host = if (length splitAuthority) > 1 then
              (last splitAuthority)
            else
              null;
          };

        homeAuthorities = map mkAuthority (attrNames self.homeConfigurations);

        homesOn = host: filter (home: host == home.host) homeAuthorities;

        mkNode = host:
          { system, hostname, sshUser, ... }:
          let
            systemProfiles = if (hasAttr host self.nixosConfigurations) then {
              system = {
                path = deploy-rs.lib.${system}.activate.nixos
                  self.nixosConfigurations.${host};
                user = "root";
              };
            } else
              { };

            mkHomeProfile = { authority, user, ... }: {
              path = deploy-rs.lib.${system}.activate.home-manager
                self.homeConfigurations.${authority};
              inherit user;
            };

            mkHomeProfilePair = homeAuthority@{ user, ... }:
              nameValuePair ("home-" + user) (mkHomeProfile homeAuthority);

            homeProfiles = listToAttrs (map mkHomeProfilePair (homesOn host));
          in {
            inherit hostname sshUser;
            profiles = systemProfiles // homeProfiles;
          };

        validNodes = filterAttrs (_: v: v ? hostname) nodes;          
      in mapAttrs mkNode validNodes;
    };
}

{
  description = "raccoon's radicool flakey nix stuff";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    deploy-rs.url = "github:serokell/deploy-rs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, deploy-rs, agenix
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
        let suffix = ".host.nix";
        in map (file: {
          path = path + ("/" + file);
          host = removeSuffix suffix file;
        }) (filter (file: hasSuffix suffix file)
          (attrNames (builtins.readDir path)));

      hostsConfig = (import ./hosts.nix) {
        lib = nixpkgs.lib;
        inherit raccoonlib;
      };

      hosts = mapAttrs (_: v: hostsConfig.default // v) hostsConfig;
    in utils.lib.mkFlake {
      lib = raccoonlib;

      overlay = (import ./pkgs) self.lib;

      # regular old `packages` doesn't like sub-sets of packages
      legacyPackages = forAllSystems (system:
        let
          prev = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in (self.overlay { } prev).rac);

      #######################
      # NixOS Configuration #
      #######################

      inherit self inputs;

      channels = {
        nixpkgs = {
          input = nixpkgs;
          overlaysBuilder = channels:
            [
              (final: prev: {
                inherit (channels.unstable) # ...
                ;
              })
            ];
        };

        unstable.input = unstable;
      };

      channelsConfig.allowUnfree = true;

      sharedOverlays = [
        nur.overlay
        agenix.overlay
        self.overlay
        (final: prev: {
          home-manager =
            prev.callPackage "${home-manager}/home-manager" { path = "./."; };
        }) # is this the right way to do this?
      ];

      hosts = listToAttrs (map (file:
        nameValuePair file.host (let host = hosts.${file.host} or hosts.default;
        in rec {
          inherit (host) system;

          modules = [
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            ./nixos/modules
            ./nixos/profiles
            file.path
            {
              system.stateVersion = host.stateVersion;

              nix.generateRegistryFromInputs = true;
            }
          ];

          specialArgs = _specialArgs.${system};
        })) (hostFilesIn ./nixos/profiles));

      ##############################
      # Home Manager Configuration #
      ##############################

      homeConfigurations = let
        userDirs = attrNames (filterAttrs (_: type: type == "directory")
          (builtins.readDir ./home));

        userHostFiles = flatten (map (username:
          map (file: { inherit username file; })
          (hostFilesIn (./home + "/${username}/profiles"))) userDirs);
      in listToAttrs (map ({ username, file }:
        nameValuePair (username + "@" + file.host)
        (let host = hosts.${file.host} or hosts.default;
        in home-manager.lib.homeManagerConfiguration {
          inherit (host) stateVersion system;
          inherit username;

          homeDirectory = "/home/${username}";

          extraSpecialArgs = _specialArgs.${host.system};

          extraModules = [
            (./home + "/${username}/modules")
            (./home + "/${username}/profiles")
            file.path
          ];

          configuration = {
            nixpkgs = {
              config = { inherit (host) allowUnfree; };

              overlays = [
                nur.overlay
                agenix.overlay
                self.overlay
                (final: prev: {
                  inherit (unstable) # ...
                  ;
                })
              ];
            };
          };
        })) userHostFiles);

      ###########################
      # deploy-rs Configuration #
      ###########################

      deploy.nodes = mapAttrs (host:
        { system, hostname, sshUser, ... }:
        let
          homesOnHost = filter (home: host == home.host) (map (authority:
            let splitAuthority = splitString "@" authority;
            in {
              inherit authority;
              user = head splitAuthority;
              host = if (length splitAuthority) > 1 then
                (last splitAuthority)
              else
                null;
            }) (attrNames self.homeConfigurations));

          systemProfiles = if (hasAttr host self.nixosConfigurations) then {
            system = {
              path = deploy-rs.lib.${system}.activate.nixos
                self.nixosConfigurations.${host};
              user = "root";
            };
          } else
            { };

          homeProfiles = listToAttrs (builtins.map ({ authority, user, ... }:
            nameValuePair ("home-" + user) {
              path = deploy-rs.lib.${system}.activate.home-manager
                self.homeConfigurations.${authority};
              inherit user;
            }) homesOnHost);
        in {
          inherit hostname sshUser;
          profiles = systemProfiles // homeProfiles;
        }) (filterAttrs (_: v: v ? hostname) hosts);
    };
}

{
  description = "raccoon's radicool flakey nix stuff";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    deploy-rs.url = "github:serokell/deploy-rs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, deploy-rs, agenix
    , home-manager }:
    with nixpkgs.lib;
    let
      hostFilesIn = let suffix = ".host.nix";
      in path:
      filter (file: hasAttr file.host hosts) (map (file: {
        path = path + ("/" + file);
        host = removeSuffix suffix file;
      }) (filter (file: hasSuffix suffix file)
        (attrNames (builtins.readDir path))));

      hosts = mapAttrs (_: v:
        {
          system = "x86_64-linux";
          allowUnfree = true;
          sshUser = "raccoon";
        } // v) {
          darvaza = { };
          oberon = { hostname = "oberon.raccoon.fun"; };
          flock-nixos = { hostname = "192.168.122.78"; };
          iso = { };
        };
    in utils.lib.systemFlake {
      lib = (import ./lib) nixpkgs.lib;

      overlay = (import ./pkgs) self.lib;

      # regular old `packages` didn't like vscode-extensions for some reason
      legacyPackages = let
        systems = [ "x86_64-linux" ];
        forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      in forAllSystems (system:
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
        self.overlay
        nur.overlay
        (final: prev: {
          home-manager =
            prev.callPackage "${home-manager}/home-manager" { path = "./."; };
        }) # is this the right way to do this?
      ];

      hosts = listToAttrs (map (file:
        nameValuePair file.host (let host = hosts.${file.host};
        in rec {
          inherit (host) system;

          modules = [
            utils.nixosModules.saneFlakeDefaults
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            ./nixos/modules
            ./nixos/profiles
            file.path
          ];

          specialArgs = {
            raccoonlib = self.lib;
            raccoonpkgs = self.legacyPackages.${system};
          };
        })) (hostFilesIn ./nixos/profiles));

      ##############################
      # Home Manager Configuration #
      ##############################

      homeConfigurations = listToAttrs (map (file:
        nameValuePair ("raccoon@" + file.host) (let host = hosts.${file.host};
        in home-manager.lib.homeManagerConfiguration rec {
          inherit (host) system;

          username = "raccoon";

          homeDirectory = "/home/${username}";

          extraSpecialArgs = {
            raccoonlib = self.lib;
            raccoonpkgs = self.legacyPackages.${system};
          };

          extraModules = [ ./home/modules ./home/profiles file.path ];

          configuration = {
            nixpkgs = {
              config = { inherit (host) allowUnfree; };

              overlays = [
                nur.overlay
                self.overlay
                (final: prev: {
                  inherit (unstable) # ...
                  ;
                })
              ];
            };
          };
        })) (hostFilesIn ./home/profiles));

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

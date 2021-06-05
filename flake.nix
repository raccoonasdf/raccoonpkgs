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
    utils.lib.systemFlake {

      #################
      # Extra Outputs #
      #################

      lib = import ./lib;

      overlay = (import ./pkgs) self.lib;

      #######################
      # NixOS Configuration #
      #######################

      inherit self inputs;

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

      hosts = let inherit (nixpkgs) lib;
      in with lib;
      let
        suffix = ".host.nix";

        hostFiles = filterAttrs (n: _: hasSuffix suffix n)
          (builtins.readDir ./nixos/profiles);

        hosts = mapAttrs' (n: _:
          nameValuePair (removeSuffix suffix n) ({
            modules = [ (./nixos/profiles + ("/" + n)) ];
          })) hostFiles;
      in hosts;

      hostDefaults = {
        system = "x86_64-linux";
        modules = [
          utils.nixosModules.saneFlakeDefaults
          agenix.nixosModules.age
          home-manager.nixosModules.home-manager
          (import ./nixos/modules)
          (import ./nixos/profiles)
        ];
      };

      ##############################
      # Home Manager Configuration #
      ##############################

      homeConfigurations = let
        mkHomes = with nixpkgs;
          lib.mapAttrs (profile:
            { modules, system ? "x86_64-linux" }:
            home-manager.lib.homeManagerConfiguration rec {
              inherit system;

              username = builtins.elemAt (lib.splitString "@" profile) 0;

              homeDirectory = "/home/${username}";

              configuration = { ... }: {
                nixpkgs = {
                  config.allowUnfree = true;

                  overlays = [
                    nur.overlay
                    self.overlay
                    (final: prev: {
                      inherit (unstable) # ...
                      ;
                    })
                  ];
                };

                imports = modules ++ [ ./home/modules ./home/profiles ];
              };
            });
      in let inherit (nixpkgs) lib;
      in with lib;
      let
        hostFiles = filterAttrs (n: _: hasSuffix ".host.nix" n)
          (builtins.readDir ./home/profiles);

        hosts = mapAttrs' (n: _:
          nameValuePair ("raccoon@" + (removeSuffix ".host.nix" n)) ({
            modules = [ (./home/profiles + ("/" + n)) ];
          })) hostFiles;
      in mkHomes (hosts // { raccoon = { }; });

      ###########################
      # deploy-rs Configuration #
      ###########################

      deploy.nodes = let
        systemNode = { host, hostname, sshUser ? "raccoon", profiles ? { }
          , home ? false }: {
            inherit hostname sshUser;
            profiles = profiles // {
              system = {
                path = deploy-rs.lib.x86_64-linux.activate.nixos
                  self.nixosConfigurations.${host};
                user = "root";
              } // (if home then {
                home = {
                  path = deploy-rs.lib.x86_64-linux.activate.home-manager
                    self.homeConfigurations."${sshUser}@${host}";
                  user = sshUser;
                };
              } else
                { });
            };
          };

        systemNodes = nixpkgs.lib.mapAttrs
          (host: attrs: systemNode ({ inherit host; } // attrs));
      in systemNodes {
        oberon.hostname = "oberon.raccoon.fun";
        flock-nixos = {
          hostname = "192.168.122.78";
          home = true;
        };
      };
    };
}

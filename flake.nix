{
  description = "raccoon's nix packages";

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

    nix-home = {
      url = "github:raccoonasdf/nix-home";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.unstable.follows = "unstable";
      inputs.nur.follows = "nur";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = inputs@{ self, nixpkgs, unstable, nur, utils, deploy-rs, agenix
    , home-manager, nix-home }:
    utils.lib.systemFlake {
      inherit self inputs;

      lib = import ./lib;

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
          home-manager = prev.callPackage "${home-manager}/home-manager" { path = "./."; };
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
        modules = [
          utils.nixosModules.saneFlakeDefaults
          agenix.nixosModules.age
          home-manager.nixosModules.home-manager
          (import ./nixos/modules)
          (import ./nixos/profiles)
        ];
      };

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
                    nix-home.homeConfigurations."${sshUser}@${host}";
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

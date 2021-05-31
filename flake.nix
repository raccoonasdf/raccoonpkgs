{
  description = "raccoon's nix packages";
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/release-21.05;
  };

  outputs = { self, nixpkgs }:
  let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    overlay = import ./.;
    packages = forAllSystems (system:
    let
      prev = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in ((import ./.) {} prev).rac);
  };
}
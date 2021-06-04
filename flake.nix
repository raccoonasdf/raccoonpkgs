{
  description = "raccoon's nix packages";

  outputs = { self, nixpkgs }: {
    overlay = (import ./pkgs) self.lib;

    lib = import ./lib;

    packages = let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in forAllSystems (system:
      let
        prev = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in (self.overlay { } prev).rac);
  };
}

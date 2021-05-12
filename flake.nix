{
  description = "raccoon's nix packages";
  outputs = { self }: {
    overlay = final: prev: {
      raccoonpkgs = import ./default.nix;
    };
  };
}
{
  description = "raccoon's nix packages";
  outputs = { self }: {
    overlay = final: prev: {
      rac = import ./default.nix;
    };
  };
}
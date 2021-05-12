{
  description = "raccoon's nix packages";
  outputs = { self }: {
    overlay = import ./default.nix;
  };
}
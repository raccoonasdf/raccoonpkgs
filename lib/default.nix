lib:
let
  raccoonlib = lib.makeExtensible (self:
    let
      callLibs = file:
        import file {
          inherit lib;
          raccoonlib = self;
        };
    in { maintainers = import ./maintainer-list.nix; });
in raccoonlib

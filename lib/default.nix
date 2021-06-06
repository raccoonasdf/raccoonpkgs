lib:
let
  raccoonlib = lib.makeExtensible (self:
    let
      callLibs = file:
        import file {
          inherit lib;
          raccoonlib = self;
        };
    in {
      system = callLibs ./system.nix;
      maintainers = import ./maintainer-list.nix;

      inherit (self.system) systems defaultSystem forAllSystems;
    });
in raccoonlib

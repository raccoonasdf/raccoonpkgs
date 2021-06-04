{ lib, config, ... }:
with lib;
let cfg = config.raccoon.box;
in {
  options.raccoon.box = {
    enable = mkEnableOption "box";

    mount = mkOption {
      type = types.str;
      default = "/rac";
    };
  };

  config = let box = cfg.mount;
  in mkIf cfg.enable {
    raccoon.places = {
      inherit box;
      screenshots = "${box}/screenshots";
    };

    home.sessionVariables.GNUPGHOME = "${box}/keys/gpg";
  };
}

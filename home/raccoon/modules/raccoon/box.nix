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

    enableUserDirs = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = let box = cfg.mount;
  in mkIf cfg.enable {
    raccoon.places = {
      inherit box;
      screenshots = "${box}/screenshots";
    };

    home.sessionVariables.GNUPGHOME = "${box}/keys/gpg";

    xdg.userDirs = mkIf cfg.enableUserDirs {
      enable = true;
      documents = "${box}/dump/xdg-documents";
      download = "${box}/dump";
      music = "${box}/audio";
      pictures = "${box}/visual";
      videos = "${box}/visual";
    };
  };
}

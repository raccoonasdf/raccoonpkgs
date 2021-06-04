{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.programs.blesh;

  renderFaces = faces:
    (concatStringsSep "\n" (mapAttrsToList renderFace faces)) + "\n";

  renderFace = n: v: "ble-color-setface ${n} ${v}";
in {
  options.programs.blesh = {
    enable = mkEnableOption "ble.sh";

    faces = mkOption {
      type = with types; attrsOf str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.bash.initExtra = ''
      source ${pkgs.rac.blesh}/share/blesh/ble.sh
    '';
    xdg.configFile."blesh/init.sh".text = renderFaces cfg.faces;
  };
}

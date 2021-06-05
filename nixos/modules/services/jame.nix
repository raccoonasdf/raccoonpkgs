{ config, raccoonpkgs, lib, ... }:
with lib;
let cfg = config.services.jame;
in {
  options.services.jame = {
    enable = mkEnableOption "jame";

    environmentFile = mkOption {
      type = with types; str;
      description = ''
        Path to file containing environment variables for jame.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jame = {
      description = "Our friend jame";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = "jame";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = "${raccoonpkgs.jame}/bin/jame";
        Restart = "always";
      };
    };

    users = {
      users.jame = {
        isSystemUser = true;
        group = "jame";
      };
      groups.jame = { };
    };
  };
}

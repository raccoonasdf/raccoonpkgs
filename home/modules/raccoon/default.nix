attrs@{ lib, pkgs, config, ... }:
with lib;
let cfg = config.raccoon;
in {
  imports = [ ./box.nix ];

  options.raccoon = {
    lib = mkOption {
      type = types.attrs;
      default = (import ../../lib) attrs;
    };

    places = {
      box = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      screenshots = mkOption {
        type = with types; nullOr str;
        default = null;
      };
      
      wallpaper = mkOption {
        type = with types; nullOr str;
        default = null;
      };
    };

    graphical = mkOption {
      type = types.bool;
      default = false;
    };

    styles = {
      colors = mkOption {
        type = types.attrs;
        default = cfg.lib.schemes.default-dark;
      };

      fonts = {
        packages = mkOption {
          type = with types; listOf package;
          default = [ pkgs.input-fonts ];
        };

        body = mkOption {
          type = types.str;
          default = "Input Sans";
        };

        header = mkOption {
          type = types.str;
          default = "Input Serif";
        };

        mono = mkOption {
          type = types.str;
          default = "Input Mono";
        };

        extraNixpkgsConfig = mkOption {
          type = types.attrs;
          default = { input-fonts.acceptLicense = true; };
        };
      };
    };
  };

  config = mkIf cfg.graphical {
    home.packages = cfg.styles.fonts.packages;
    fonts.fontconfig.enable = true;
    nixpkgs.config = cfg.styles.fonts.extraNixpkgsConfig;

    raccoon.places = mkDefault {
      screenshots = "${config.xdg.userDirs.pictures}/screenshots";
      wallpaper =
        toString (cfg.lib.base16ify cfg.styles.colors ./wallpaper.png);
    };
  };
}

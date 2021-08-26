{ config, pkgs, raccoonpkgs, ... }:
let styles = config.raccoon.styles;
in let
  colors = styles.colors.hashed;
  fonts = styles.fonts;
in let
  # basic colors
  dark = colors.base01;
  light = colors.base04;
  urgent = colors.base08;

  # status colors
  info = colors.base0d;
  good = colors.base0b;
  warning = colors.base0a;

  font = fonts.header;
  fontconf = {
    names = [ font ];
    style = "Regular";
    size = 8.0;
  };
in {
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      settings = {
        theme.overrides = {
          idle_bg = dark;
          idle_fg = light;
          info_bg = dark;
          info_fg = info;
          good_bg = dark;
          good_fg = good;
          warning_bg = dark;
          warning_fg = warning;
          critical_bg = dark;
          critical_fg = urgent;
          separator = "|";
          separator_bg = "auto";
          separator_fg = "light";
        };
        icons.overrides = { time = "it is"; };
      };
      blocks = [
        {
          block = "custom";
          shell = "sh";
          command = "echo `whoami`@`hostname`";
          interval = "once";
        }
        {
          block = "time";
          format = "%a %F at %T%z";
          interval = 1;
        }
      ];
    };
  };

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = let places = config.raccoon.places;
      in {
        focus.mouseWarping = false;
        workspaceLayout = "stacked";

        modifier = "Mod4";

        modes = { };

        startup = with pkgs; [{
          always = true;
          notification = false;
          command =
            "${feh}/bin/feh --no-fehbg --bg-fill --geometry +0 -- ${places.wallpaper}";
        }];

        keybindings = let
          mod = config.xsession.windowManager.i3.config.modifier;
          shift = "${mod}+Shift";
          alt = "${mod}+Mod1";

          screenshotsLocation =
            "${places.screenshots}/$(date +Screenshot_%F_%H-%M-%S).png";
        in with raccoonpkgs; {
          "${alt}+space" = "exec i3-sensible-terminal";
          "${mod}+d" =
            "exec ${racmenu}/bin/racmenu -b -i -l 15 -fn '${font}-9' -nb '${dark}' -nf '${light}' -sb '${light}' -sf '${dark}'";

          "Print" =
            "exec ${racscrot}/bin/racscrot -u -g 1920x1080 ${screenshotsLocation}";
          "${mod}+Print" =
            "exec ${racscrot}/bin/racscrot -u ${screenshotsLocation}";
          "Shift+Print" =
            "exec ${racscrot}/bin/racscrot -su ${screenshotsLocation}";

          # implicitly requires lightdm
          "${shift}+Home" = "dm-tool lock";
          "${shift}+Delete" = "exit";

          "${mod}+w" = "kill";

          "${shift}+f" = "floating toggle";

          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+i" = "focus child";
          "${mod}+o" = "focus parent";

          "${mod}+grave" = "workspace 0:~";
          "${mod}+1" = "workspace 1";
          "${mod}+2" = "workspace 2";
          "${mod}+3" = "workspace 3";
          "${mod}+4" = "workspace 4:...";
          "${mod}+Tab" = "scratchpad show";

          "${mod}+f" = "fullscreen toggle";

          "${shift}+h" = "move left";
          "${shift}+j" = "move down";
          "${shift}+k" = "move up";
          "${shift}+l" = "move right";

          "${shift}+grave" = "move container to workspace 0:~";
          "${shift}+1" = "move container to workspace 1";
          "${shift}+2" = "move container to workspace 2";
          "${shift}+3" = "move container to workspace 3";
          "${shift}+4" = "move container to workspace 4:...";
          "${shift}+Tab" = "move scratchpad";

          "${shift}+i" = "move workspace to output left";
          "${shift}+o" = "move workspace to output right";

          "${alt}+h" = "resize shrink width  16px or 16ppt";
          "${alt}+j" = "resize grow   height 16px or 16ppt";
          "${alt}+k" = "resize shrink height 16px or 16ppt";
          "${alt}+l" = "resize grow   width  16px or 16ppt";
        };

        floating.border = 1;
        window.border = 1;

        gaps = {
          inner = 8;
          smartBorders = "no_gaps";
          smartGaps = true;
        };

        fonts = fontconf;

        colors = {
          background = dark;

          focused = {
            background = light;
            border = light;
            childBorder = light;
            indicator = light;
            text = dark;
          };
          focusedInactive = {
            background = dark;
            border = dark;
            childBorder = dark;
            indicator = dark;
            text = light;
          };
          urgent = {
            background = urgent;
            border = urgent;
            childBorder = urgent;
            indicator = urgent;
            text = light;
          };
          unfocused = {
            background = dark;
            border = dark;
            childBorder = dark;
            indicator = dark;
            text = light;
          };
        };

        bars = [{
          statusCommand =
            "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          mode = "hide";
          trayOutput = "primary";

          fonts = fontconf;

          colors = {
            background = dark;
            separator = light;
            statusline = light;

            focusedWorkspace = {
              border = light;
              background = light;
              text = dark;
            };
            urgentWorkspace = {
              border = urgent;
              background = urgent;
              text = urgent;
            };
            activeWorkspace = {
              border = light;
              background = dark;
              text = light;
            };
            inactiveWorkspace = {
              border = dark;
              background = dark;
              text = light;
            };
          };

          extraConfig = ''
            strip_workspace_numbers yes
          '';
        }];
      };
      extraConfig = ''
        workspace 0:~ output primary
        workspace 1 output primary
        workspace 2 output primary
        workspace 3 output primary
        workspace 4:... output primary
      '';
    };
  };
}


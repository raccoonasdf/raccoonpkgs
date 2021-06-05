{ lib, config, ... }: {
  programs.qutebrowser = {
    enable = true;

    extraConfig = lib.fileContents ./config.py;

    settings = let styles = config.raccoon.styles;
    in {
      completion.web_history.max_items = 10000;
      content = {
        fullscreen.window = true;
        headers.referer = "same-domain";
      };
      hints.mode = "word";
      input.insert_mode = {
        auto_enter = false;
        auto_leave = false;
        leave_on_load = false;
      };
      keyhint.delay = 0;
      qt.highdpi = true;
      scrolling.bar = "always";

      tabs = {
        background = true;
        mode_on_change = "restore";
        position = "left";
        show = "multiple";
        width = "15%";
      };

      fonts = let fonts = styles.fonts;
      in {
        default_family = [ fonts.mono ];
        default_size = "8pt";
        tabs = {
          selected = "10pt ${fonts.body}";
          unselected = "10pt ${fonts.body}";
        };
        prompts = "10pt ${fonts.body}";
        statusbar = "10pt default_family";
      };

      colors = let colors = styles.colors.hashed;
      in with colors; {
        completion = {
          fg = base05;
          even.bg = base00;
          odd.bg = base00;
          match.fg = base0a;
          category = {
            fg = base01;
            bg = base05;
            border = {
              bottom = base05;
              top = base05;
            };
          };
          item.selected = {
            fg = base05;
            bg = base03;
            border = {
              bottom = base03;
              top = base03;
            };
          };
          scrollbar = {
            fg = base04;
            bg = base01;
          };
        };

        downloads = {
          bar.bg = base01;
          error = {
            fg = base08;
            bg = base05;
          };
          start = {
            fg = base01;
            bg = base0a;
          };
          stop = {
            fg = base01;
            bg = base0b;
          };
        };

        hints = {
          fg = base00;
          bg = base0a;
          match.fg = base03;
        };

        keyhint = {
          fg = base05;
          bg = base01;
          suffix.fg = base0a;
        };

        messages = {
          info = {
            fg = base05;
            bg = base01;
            border = base01;
          };
          warning = {
            fg = base01;
            bg = base0a;
            border = base0a;
          };
          error = {
            fg = base01;
            bg = base08;
            border = base08;
          };
        };

        prompts = {
          fg = base05;
          bg = base01;
          border = base01;
          selected.bg = base03;
        };

        statusbar = {
          caret = {
            fg = base0e;
            bg = base01;
            selection = {
              fg = base0e;
              bg = base01;
            };
          };
          command = {
            fg = base05;
            bg = base01;
          };
          insert = {
            fg = base0b;
            bg = base01;
          };
          normal = {
            fg = base05;
            bg = base01;
          };
          passthrough = {
            fg = base0d;
            bg = base01;
          };
          progress.bg = base05;
          url = {
            fg = base05;
            hover.fg = base0d;
            warn.fg = base0a;
            error.fg = base08;
            success = {
              http.fg = base05;
              https.fg = base0c;
            };
          };
        };

        tabs = {
          bar.bg = base00;
          odd = {
            fg = base05;
            bg = base01;
          };
          even = {
            fg = base05;
            bg = base00;
          };
        };
      };
    };
  };

  xdg.dataFile."qutebrowser/greasemonkey/discordstyle.user.js".text =
    builtins.readFile ./discordstyle.user.js;
}

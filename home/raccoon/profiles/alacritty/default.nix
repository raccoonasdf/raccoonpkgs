{ lib, config, ... }: {
  home.sessionVariables.TERMINAL = "alacritty";

  programs.alacritty = {
    enable = true;
    settings = let styles = config.raccoon.styles;
    in let
      font = styles.fonts.mono;
      colors = styles.colors.hexed;
    in {
      draw_bold_text_with_bright_colors = false;

      window.padding = {
        x = 6;
        y = 6;
      };

      font.normal.family = font;

      colors = with colors; {
        primary = {
          foreground = base05;
          background = base00;
        };
        cursor = {
          text = base00;
          cursor = base05;
        };
        normal = {
          black = base00;
          red = base08;
          green = base0b;
          yellow = base0a;
          blue = base0d;
          magenta = base0e;
          cyan = base0c;
          white = base05;
        };
        bright = {
          black = base03;
          red = base09;
          green = base01;
          yellow = base02;
          blue = base04;
          magenta = base06;
          cyan = base0f;
          white = base07;
        };
      };

      bell = with colors; {
        animation = "EaseOutSine";
        duration = 100;
        color = base05;
      };
    };
  };
}

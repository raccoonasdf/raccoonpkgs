{ config, ... }: {
  services.dunst = {
    enable = true;
    settings = let styles = config.raccoon.styles;
    in let
      colors = styles.colors.hashed;
      font = styles.fonts.body;
    in with colors; {
      global = {
        geometry = "302x4-8-8";
        seperator_height = 0;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 1;

        font = "${font} 8";
        markup = "full";
        format = ''
          <b>%s</b>
          %b'';
        word_wrap = true;

        frame_color = base04;
        foreground = base04;
        background = base01;
      };

      urgency_critical = {
        frame_color = base01;
        foreground = base01;
        background = base08;
      };
    };
  };
}

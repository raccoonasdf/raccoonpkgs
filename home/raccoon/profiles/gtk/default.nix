{ pkgs, config, ... }: {
  gtk = {
    enable = true;

    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };

    iconTheme = {
      package = pkgs.faba-icon-theme;
      name = "Faba";
    };

    font = {
      name = config.raccoon.styles.fonts.body;
      size = 9;
    };
  };
}

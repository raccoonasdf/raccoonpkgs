{ config, ... }: {
  imports = [ ./graphical.nix ];

  raccoon.styles.colors = config.raccoon.lib.schemes.eighties;

  home.stateVersion = "20.09";
}

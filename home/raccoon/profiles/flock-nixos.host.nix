{ config, ... }: {
  imports = [ ./graphical.nix ];

  raccoon.styles.colors = config.raccoon.lib.schemes.eighties;
}

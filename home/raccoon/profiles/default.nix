{ lib, pkgs, config, ... }: {
  imports = [ ./bash ./fish ./git ./htop ./kakoune ./ranger ./ssh ];

  home.packages = with pkgs; [ atool fd manix nixfmt ripgrep ];

  programs.bat = { enable = true; };

  programs.eza = {
    enable = true;
    enableAliases = true;
  };
}

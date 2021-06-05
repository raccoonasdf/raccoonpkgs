{ lib, pkgs, config, ... }: {
  imports = [ ./fish ./git ./htop ./kakoune ./ranger ./ssh ];

  home.packages = with pkgs; [ atool fd manix nixfmt ripgrep ];

  programs.bat = { enable = true; };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}

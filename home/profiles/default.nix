{ lib, pkgs, config, ... }: {
  imports = [ ./fish ./git ./i3 ./kakoune ./ranger ./ssh ];

  home.packages = with pkgs; [ atool fd manix nixfmt ripgrep ];

  programs.bat = { enable = true; };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}

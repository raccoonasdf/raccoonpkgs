{ lib, pkgs, config, ... }: {
  imports = [ ./fish ./git ./i3 ./kakoune ./ranger ];

  home.packages = with pkgs; [ atool fd manix ripgrep ];

  programs.bat = { enable = true; };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };
}

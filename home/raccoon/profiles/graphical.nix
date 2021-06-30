{ pkgs, ... }: {
  imports =
    [ ./alacritty ./dunst ./gammastep ./gtk ./i3 ./mpv ./qutebrowser ./vscode ];

  home.packages = with pkgs; [ dragon-drop ];

  xsession.pointerCursor = {
    package = pkgs.openzone-cursors;
    name = "OpenZone_Black";
  };

  raccoon.graphical = true;
}
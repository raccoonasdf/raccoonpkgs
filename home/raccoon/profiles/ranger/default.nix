{ lib, config, ... }: {
  programs.ranger = {
    enable = true;

    bindings.browser.gb = let places = config.raccoon.places;
    in lib.mkIf (places.box != null) "cd ${places.box}";

    settings = {
      column_ratios = "1,4,5";
      vcs_aware = true;
    };

    rifleConfig = ''
      mime ^image, has mtpaint, X, flag f = mtpaint -- "$@"
      has wine, ext exe = wine "$1"
      has dragon, X, flag f = dragon -a -x "$@"
    '';
  };
}

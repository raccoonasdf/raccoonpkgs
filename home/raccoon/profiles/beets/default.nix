{ config, ... }: {
  programs.beets = {
    enable = true;
    settings = let dir = "${config.raccoon.places.box}/published-media/music";
    in {
      directory = dir;
      library = "${dir}/library.db";
      statefile = "${dir}/state.pickle";

      plugins = "edit fetchart embedart fuzzy info missing mpdupdate";
      original_date = false;

      paths = {
        default = "$albumartist/$album%aunique{}/$track $title";
        singleton = "$artist/$title";
        comp = "$albumartist/$album%aunique{}/$track $title";
      };

      embedart = {
        ifempty = true;
        remove_art_file = true;
      };
    };
  };
}

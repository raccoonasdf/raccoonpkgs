{ lib, config, ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.raccoon.places.box}/published-media/music";
    extraConfig = ''
      audio_output {
        type "pulse"
        name "MPD"
      }
    '';
  };

  programs.ncmpcpp = lib.mkIf config.raccoon.graphical {
    enable = true;
    settings = {
      clock_display_seconds = true;
      display_bitrate = true;
      ignore_leading_the = true;
      lyrics_fetchers = "genius, metrolyrics, internet";
      playlist_disable_highlight_delay = 0;
      screen_switcher_mode = "playlist, media_library";
      space_add_mode = "always_add";

      media_library_primary_tag = "album_artist";
      song_status_format = "$0{$8%t$9} by {$3%a$9} on {$5%b}";
      song_columns_list_format = "(30)[green]{a} (40)[]{t|f} (30)[blue]{b}";

      main_window_color = "default";
      header_window_color = "cyan";
      volume_color = "cyan";
      progressbar_color = "red";
    };
  };
}

{
  programs.mpv = {
    enable = true;

    config = {
      no-input-default-bindings = true;
      keep-open = true;
      profile = "gpu-hq";
    };

    bindings = {
      ESC = "set fullscreen no";
      MBTN_LEFT_DBL = "cycle fullscreen";

      SPACE = "cycle pause";
      MBTN_RIGHT = "cycle pause";

      m = "cycle mute";

      L = ''cycle-values loop-file "inf" "no"'';

      # sometimes youtube hangs when left idle, reload fixes it    
      r = ''write-watch-later-config ; loadfile "''${path}"'';

      WHEEL_DOWN = "add volume -1";
      WHEEL_UP = "add volume 1";
      "-" = "add volume -5";
      "=" = "add volume 5";
      "+" = "add volume 5";

      LEFT = "seek -2 exact";
      RIGHT = "seek 2 exact";
      UP = "seek -5 exact";
      DOWN = "seek 5 exact";
      h = "seek -2 exact";
      l = "seek 2 exact";
      j = "seek -5 exact";
      k = "seek 5 exact";
      "," = "frame-back-step";
      "." = "frame-step";

      "<" = "playlist-prev";
      ">" = "playlist-next";
      PGUP = "add chapter -1";
      PGDWN = "add chapter 1";

      "[" = "add speed -0.1";
      "]" = "add speec 0.1";
      "{" = "add speed -0.5";
      "}" = "add speed 0.5";
      "\\" = "set speed 1.0";

      PLAY = "play";
      PAUSE = "pause";
      PLAYPAUSE = "cycle pause";

      MUTE = "cycle mute";

      REWIND = "seek -5 exact";
      FORWARD = "seek 5 exact";

      PREV = "playlist-prev";
      NEXT = "playlist-next";

      VOLUME_DOWN = "add volume -2";
      VOLUME_UP = "add volume 2";

      CLOSE_WIN = "quit";
    };
  };
}

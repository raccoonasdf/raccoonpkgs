{ config, ... }: {
  programs.htop = {
    enable = true;

    settings = with config.lib.htop;
      {
        hide_threads = true;

        fields = with fields; [ PID USER M_RESIDENT IO_RATE COMM ];
      } // leftMeters [ (bar "LeftCPUs2") (bar "Memory") (bar "Swap") ]
      // rightMeters [ (bar "RightCPUs2") (text "Tasks") (text "LoadAverage") ];
  };
}

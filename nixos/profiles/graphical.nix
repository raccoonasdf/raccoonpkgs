{
  # so that home manager can set the gtk theme
  programs.dconf.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  services.xserver = {
    enable = true;
    displayManager = {
      # so that home manager's xsession still works even if the system has no sessions
      session = [{
        manage = "window";
        name = "fake";
        start = "";
      }];

      lightdm.enable = true;
    };
  };
}

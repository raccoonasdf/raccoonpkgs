let config = import ./config.nix;
in {
  services.thelounge = {
    enable = true;
    extraConfig = {
      reverseProxy = true;
      prefetch = true;
      leaveMessage = "bye";

      fileUpload = {
        enable = true;
        maxFileSize = -1;
      };

      defaults = {
        name = "";
        host = "";
        nick = "raccoonasdf";
        username = "raccoon";
        realname = "raccoon!";
        join = "";
      };
    };
  };

  services.nginx.virtualHosts = {
    "lounge.${config.domain}" = {
      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://[::1]:9000";
    };
  };
}

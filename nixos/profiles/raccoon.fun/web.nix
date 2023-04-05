{ config, ... }:
let c = import ./config.nix;
in {
  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    appendHttpConfig = ''
      types {
        text/plain nix;
        application/json theme;
      }
    '';

    virtualHosts = {
      "${c.domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."/".return = "301 https://www.${c.domain}$request_uri";
      };

      "www.${c.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${c.root}/zone";

        # ssg-defined configs without a rebuild
        extraConfig = "include ${c.root}/zone/nginx.conf;";
      };

      "bits.${c.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${c.root}/bits";

        locations = {
          "/" = { tryFiles = "$uri $uri/ $uri.html =404"; };

          "/nixos-guide/src/".extraConfig = "autoindex on;";

          "/index/".extraConfig = "autoindex on;";
        };
      };

      "brownies.${c.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${c.root}/brownies";
        extraConfig = "error_page 404 /404/;";

        locations = {
          "/".tryFiles = "$uri $uri/ $uri.html =404";
          "/404/".extraConfig = "internal;";
        };
      };
    };
  };

  services.phpfpm.pools.raccoon = {
    user = "phpfpm";
    settings = {
      pm = "ondemand";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 8;
    };
  };

  users = {
    users.phpfpm = {
      isSystemUser = true;
      group = "phpfpm";
    };
    groups.phpfpm = { };
  };
}

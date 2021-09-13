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

        extraConfig = ''
          error_page 403 404 /errors/4xx.html;
          error_page 500 502 503 504 /errors/5xx.html;

          limit_rate 192k;
        '';

        locations = {
          "~ \.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.raccoon.socket};
            fastcgi_index index.php;
          '';
          "/" = {
            index = "index.html index.php";
            tryFiles = "$uri $uri/ $uri.html =404";
          };
          "/errors/".extraConfig = "internal;";
        };
      };

      "bits.${c.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${c.root}/bits";

        locations = {
          "/" = { tryFiles = "$uri $uri/ $uri.html =404"; };

          "/nixos-guide/src/" = {
            extraConfig = ''
              autoindex on;
              types {
                application/json theme;
              }
            '';
          };
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
    user = "nobody";
    settings = {
      pm = "ondemand";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 8;
    };
  };
}

let config = import ./config.nix;
in {
  services.nginx = {
    enable = true;
    enableReload = true;

    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "${config.domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."/".return = "301 https://www.${config.domain}$request_uri";
      };

      "www.${config.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${config.root}/zone";

        extraConfig = ''
          error_page 403 404 /errors/4xx.html;
          error_page 500 502 503 504 /errors/5xx.html;

          limit_rate 192k;
        '';

        locations = {
          "/".tryFiles = "$uri $uri/ $uri.html =404";
          "/errors/".extraConfig = "internal;";
        };
      };

      "bits.${config.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${config.root}/bits";

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

      "brownies.${config.domain}" = {
        forceSSL = true;
        enableACME = true;
        root = "${config.root}/brownies";
        extraConfig = "error_page 404 /404/;";

        locations = {
          "/".tryFiles = "$uri $uri/ $uri.html =404";
          "/404/".extraConfig = "internal;";
        };
      };
    };
  };
}

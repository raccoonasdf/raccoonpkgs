{ pkgs, ... }:
let config = import ./config.nix;
in {
  services.postgresql = {
    enable = true;
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.matrix-synapse = {
    enable = true;
    server_name = "${config.domain}";
    extraConfig = ''
      limit_remote_rooms:
        enabled: true
        complexity: 32.0
    '';

    listeners = [{
      port = 8008;
      bind_address = "::1";
      type = "http";
      tls = false;
      x_forwarded = true;

      resources = [{
        names = [ "client" "federation" ];
        compress = false;
      }];
    }];
  };

  services.nginx.virtualHosts = {
    "${config.domain}".locations = {
      "= /.well-known/matrix/server" =
        let server = { "m.server" = "matrix.${config.domain}:443"; };
        in {
          extraConfig = "add_header Content-Type application/json;";
          return = "200 '${builtins.toJSON server}'";
        };

      "= /.well-known/matrix/client" = let
        client = {
          "m.homeserver" = { "base_url" = "https://matrix.${config.domain}"; };

          "m.identity_server" = { "base_url" = "https://vector.im"; };
        };
      in {
        extraConfig = ''
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin *;
        '';

        return = "200 '${builtins.toJSON client}'";
      };
    };

    "matrix.${config.domain}" = {
      forceSSL = true;
      enableACME = true;

      locations = {
        "/".return = "301 https://element.matrix.${config.domain}";
        "/_matrix".proxyPass = "http://[::1]:8008";
      };
    };

    "element.matrix.${config.domain}" = {
      forceSSL = true;
      enableACME = true;

      root = pkgs.element-web.override {
        conf = {
          default_server_config."m.homeserver" = {
            "base_url" = "https://matrix.${config.domain}";
            "server_name" = "${config.domain}";
          };
        };
      };
    };
  };
}

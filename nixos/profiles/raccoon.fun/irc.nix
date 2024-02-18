let config = import ./config.nix;
in {lib, ...}: {
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

  networking.firewall.allowedTCPPorts = [ 6697 ];

  services.ergochat = {
    enable = true;
    settings = {
      server = {
        name = "irc.raccoon.fun";

        listeners = lib.mkForce {
          ":6697" = {
            tls = {
              cert = "/var/lib/acme/irc.raccoon.fun/fullchain.pem";
              key = "/var/lib/acme/irc.raccoon.fun/key.pem";
            };
          };
        };

        #listeners."/run/ergochat/ergochat.sock" = {};
        # 0o777
        #unix-bind-mode = 511;
        ip-cloaking = {
          enabled = true;
          netname = "cloaked";
          num-bits = 0;
        };
      };
      accounts = {
        registration.enabled = false;
        require-sasl = {
          enabled = true;
          #exempted = [ "localhost" "107.132.188.159" ];
        };
      };
      oper-classes = {
        "mod" = {
          title = "moderator";
          capabilities = [
            "kill"
            "ban"
            "nofakelag"
            "relaymsg"
            "vhosts"
            "sajoin"
            "samode"
            "snomasks"
          ];
        };
        "admin" = {
          title = "admin";
          extends = "mod";
          capabilities = [
            "rehash"
            "accreg"
            "chanreg"
            "history"
            "defcon"
            "massmessage"
            "roleplay"
          ];
        };
      };
      opers = {
        "socks" = {
          class = "admin";
          hidden = true;
          whois-line = "the big cheese";
          certfp = "c595b7b83c66c86184ea305e8c80e3371b8c87bad0f1b511853e7bacde5d1286"; 
          auto = true;
        };
      };
    };
  };

  users = {
    groups.ircd = {};
    users = {
      nginx.extraGroups = [ "ircd" ];
    };
  };

  security.acme.certs."irc.raccoon.fun".group = "ircd";

  systemd.services.ergochat.serviceConfig.SupplementaryGroups = "ircd";

  services.nginx = {
    # streamConfig = ''
    #   server {
    #     listen 6697 ssl;
    #     listen [::]:6697 ssl;

    #     ssl_certificate /var/lib/acme/irc.raccoon.fun/fullchain.pem;
    #     ssl_certificate_key /var/lib/acme/irc.raccoon.fun/key.pem;
    #     ssl_ciphers "TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384";
    #     ssl_protocols TLSv1.3;

    #     proxy_pass unix:/run/ergochat/ergochat.sock;
    #     proxy_protocol on;
    #   }
    # '';
    virtualHosts = {
      "irc.${config.domain}" = {
        forceSSL = true;
        enableACME = true;
      };
      "lounge.irc.${config.domain}" = {
        forceSSL = true;
        enableACME = true;

        locations."/".proxyPass = "http://[::1]:9000";
      };
    };
  };
}

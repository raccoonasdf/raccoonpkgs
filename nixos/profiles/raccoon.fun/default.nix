{pkgs, ...}: {
  imports = [ ./web.nix ./matrix.nix ./irc.nix ./dokuwiki.nix ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "raccoon@raccoon.fun";
  };

  services.postgresql.package = pkgs.postgresql_16;
}

{
  imports = [ ./web.nix ./matrix.nix ./thelounge.nix ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    defaults.email = "raccoon@raccoon.fun";
  };
}

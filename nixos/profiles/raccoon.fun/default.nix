{
  imports = [ ./static.nix ./matrix.nix ./thelounge.nix ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme = {
    acceptTerms = true;
    email = "raccoon@raccoon.fun";
  };
}

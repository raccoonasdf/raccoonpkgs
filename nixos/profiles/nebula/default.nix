{
  services.nebula.networks.raccoonnet = {
    enable = true;

    ca = "/etc/nebula/ca.crt";
    cert = "/etc/nebula/host.crt";
    key = "/etc/nebula/host.key";

    isLighthouse = true;

    firewall = {
      outbound = [{
        port = "any";
        proto = "any";
        host = "any";
      }];
      inbound = [ ];
    };
  };
}

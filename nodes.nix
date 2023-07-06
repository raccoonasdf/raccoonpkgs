{
  default = {
    system = "x86_64-linux";
    allowUnfree = true;
    sshUser = "raccoon";
    stateVersion = "20.09";
  };

  oberon = { hostname = "oberon.raccoon.fun"; };
  flock-nixos = { hostname = "192.168.122.78"; };
}

{ raccoonlib, ... }:
{
  default = {
    system = raccoonlib.defaultSystem;
    allowUnfree = true;
    sshUser = "raccoon";
  };
  oberon = { hostname = "oberon.raccoon.fun"; };
  flock-nixos = { hostname = "192.168.122.78"; };
}

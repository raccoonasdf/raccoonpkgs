let keys = import ./keys.nix;
in with keys; {
  jame-environment.publicKeys = [ raccoon oberon ];
}

let keys = import ./keys.nix;
in with keys; {
  oberon-raccoon-password.publicKeys = [ raccoon oberon ];
  flock-nixos-raccoon-password.publicKeys = [ raccoon flock-nixos ];

  jame-environment.publicKeys = [ raccoon oberon ];
}

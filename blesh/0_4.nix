import ./generic.nix {
  version = "0.4.0-devel2";
  rev = "276baf24d47ef1df2b000b00461a4e6d9a7b1529";
  hash = "sha256-UI+b+LOoUpDxNbO2vneWT3v0YdfWoDgeLJmbTqCXzQk=";
  patches = [ ./0_4.patch ];
}

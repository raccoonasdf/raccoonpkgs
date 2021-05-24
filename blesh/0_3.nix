import ./generic.nix {
  version = "0.3.3";
  rev = "7fa584c42d25f379319fc82c6020b7bcf63f902b";
  hash = "sha256-Gfo2S1t5Kdy+8TEDS4M5yhyRShvzQIljdE0MQK1CL+4=";
  patches = [ ./0_3.patch ];
}
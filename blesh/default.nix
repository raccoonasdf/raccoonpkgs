{ lib, stdenv, fetchFromGitHub, git }:
stdenv.mkDerivation {
  pname = "blesh";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "7fa584c42d25f379319fc82c6020b7bcf63f902b";
    hash = "sha256-Gfo2S1t5Kdy+8TEDS4M5yhyRShvzQIljdE0MQK1CL+4=";
  };

  nativeBuildInputs = [ git ];

  installPhase = ''
    make install INSDIR=$out/share/blesh
    sed -i "s%PATH=/bin:/usr/bin %%" $out/share/blesh/ble.sh
  '';

  meta = with lib; {
    description = "A command line editor written in pure Bash scripts which replaces the default GNU Readline.";
    license = licenses.bsd3;
    maintainers = with import ../maintainer-list.nix; [ raccoon ];
  };
}
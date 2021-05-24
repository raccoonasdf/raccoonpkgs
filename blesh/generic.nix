{ version, rev, hash }:
{ lib, stdenv, fetchFromGitHub, git }:
stdenv.mkDerivation {
  pname = "blesh";
  inherit version;

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    inherit rev hash;
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
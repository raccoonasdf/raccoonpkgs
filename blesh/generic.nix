{ version, rev, hash, patches }:
{ lib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation {
  pname = "blesh";
  inherit version patches;

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    inherit rev hash;
  };

  installPhase = ''
    make install INSDIR=$out/share/blesh
  '';

  meta = with lib; {
    description =
      "A command line editor written in pure Bash scripts which replaces the default GNU Readline.";
    license = licenses.bsd3;
    maintainers = with import ../maintainer-list.nix; [ raccoon ];
  };
}

{ stdenv }:

stdenv.mkDerivation {
  pname = "racscrot";
  version = "1";

  src = ./src;

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin
  '';
}
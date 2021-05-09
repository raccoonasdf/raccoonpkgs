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

  meta = with lib; {
    description = "Little script that screenshots and then opens dragon for a drag source.";
    license = licenses.unfree;
    maintainers = with import ../maintainer-list.nix; [ raccoon ];
  };    
}
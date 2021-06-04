{ lib, rac-lib, stdenv, makeWrapper, nixos-install-tools, nixfmt }:
stdenv.mkDerivation {
  pname = "raccoon-install-tools";
  version = "1";

  src = ./src;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a $src/. $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/raccoon-generate-host-config --prefix PATH ":" "${
      lib.makeBinPath [ nixos-install-tools nixfmt ]
    }"
  '';

  meta = with lib; with rac-lib; {
    description = "Some scripts for installing raccoon's nixos configs.";
    maintainers = [ maintainers.raccoon ];
  };
}

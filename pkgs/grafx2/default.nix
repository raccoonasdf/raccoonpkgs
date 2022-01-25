{ fetchurl, grafx2, fontconfig, libtiff }:

grafx2.overrideAttrs (old: {
  version = "2.7.2978";

  src = fetchurl {
    url = "http://pulkomandy.tk/projects/GrafX2/downloads/53";
    name = "grafx2-2.7.2978-src.tgz";
    hash = "sha256-9tKsvr4hTlql6XpL9nKX3f2Gz2DriTlAmKrLFUA6iuM=";
  };

  buildInputs = old.buildInputs ++ [ fontconfig libtiff ];

  installPhase = ''
    make install DESTDIR=$out PREFIX=""
  '';

  meta = old.meta // { mainProgram = "grafx2-sdl"; };
})

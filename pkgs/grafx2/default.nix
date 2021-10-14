{ lib, raccoonlib, stdenv, fetchurl, SDL, SDL_image, SDL_ttf, zlib, fontconfig, libpng, libtiff, pkg-config, lua5 }:

stdenv.mkDerivation rec {
  pname = "grafx2";
  version = "2.7.2978";

  src = fetchurl {
    url = "http://pulkomandy.tk/projects/GrafX2/downloads/53";
    name = "grafx2-2.7.2978-src.tgz";
    hash = "sha256-9tKsvr4hTlql6XpL9nKX3f2Gz2DriTlAmKrLFUA6iuM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_image SDL_ttf fontconfig libpng libtiff zlib lua5 ];

  preBuild = "cd src";

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out PREFIX=""
  '';

  meta = with lib; with raccoonlib; {
    description = "Bitmap paint program inspired by the Amiga programs Deluxe Paint and Brilliance";
    homepage = "http://grafx2.chez.com";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.raccoon ];
  };
}
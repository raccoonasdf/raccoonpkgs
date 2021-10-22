{ lib, raccoonlib, stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
    pname = "dejsonlz4";
    version = "1.1";
    src = fetchFromGitHub {
      owner = "avih";
      repo = pname;
      rev = "c4305b8807c357301f8b3e013b95242035ec1a52";
      sha256 = "sha256-GTrCGpWeBT7R4fmAK4RERkdwjMo/Etrl+6jS4GrTybc=";
    };

    buildPhase = ''
      ${stdenv.cc.targetPrefix}cc -o dejsonlz4 src/dejsonlz4.c src/lz4.c
      mv src/ref_compress/jsonlz4.c src/
      ${stdenv.cc.targetPrefix}cc -o jsonlz4 src/jsonlz4.c src/lz4.c
    '';

    installPhase = ''
      mkdir -p $out/bin/
      cp dejsonlz4 $out/bin/
      cp jsonlz4 $out/bin/
    '';

    meta = with lib; {
      description = "Decompress Mozilla Firefox bookmarks backup files";
      homepage = "https://github.com/avih/dejsonlz4";
      license = licenses.bsd2;
      maintainers = with maintainers; with raccoonlib.maintainers; [ mt-caret raccoon ];
      platforms = platforms.all;
    };
  }
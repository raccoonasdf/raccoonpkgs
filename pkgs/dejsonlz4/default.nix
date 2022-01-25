{ dejsonlz4, lib, raccoonlib, stdenv, fetchFromGitHub }:
dejsonlz4.overrideAttrs (old: {
  version = "git";

  src = fetchFromGitHub {
    owner = "avih";
    repo = old.pname;
    rev = "c4305b8807c357301f8b3e013b95242035ec1a52";
    sha256 = "sha256-GTrCGpWeBT7R4fmAK4RERkdwjMo/Etrl+6jS4GrTybc=";
  };

  buildPhase = old.buildPhase + ''
    mv src/ref_compress/jsonlz4.c src/
    ${stdenv.cc.targetPrefix}cc -o jsonlz4 src/jsonlz4.c src/lz4.c
  '';

  installPhase = old.installPhase + ''
    cp jsonlz4 $out/bin/
  '';

  meta = old.meta // { mainProgram = "dejsonlz4"; };
})

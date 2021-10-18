{ lib, raccoonlib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, dpkg, gtk2
, gnuplot, timidity }:

let
  libgnat = stdenv.mkDerivation {
    pname = "libgnat";
    version = "4.9";

    src = fetchurl {
      url =
        "http://ftp.us.debian.org/debian/pool/main/g/gnat-4.9/libgnat-4.9_4.9.2-1_amd64.deb";
      hash = "sha256-nWJYqd6k541Oa9mZbgD2c/EWnfGqANtxPHFvIgEbNjg=";
    };

    nativeBuildInputs = [ dpkg autoPatchelfHook ];

    unpackPhase = ''
      mkdir tmp
      dpkg-deb -x $src tmp

      mkdir -p out/lib
      cp -r tmp/usr/lib/x86_64-linux-gnu/. out/lib/

      sourceRoot=out
    '';

    installPhase = ''
      mkdir -p $out
      cp -r . $out/
    '';
  };
in stdenv.mkDerivation {
  pname = "scala-music";
  version = "2.44w";

  src = fetchurl {
    url = "http://www.huygens-fokker.org/software/scala-22-pc64-linux.tar.bz2";
    hash = "sha256-FUlKLhHLA1iwx1AJEjtS0lr+En5pbIzhPCmTS44XyME=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ gtk2 libgnat gnuplot timidity ];

  installPhase = ''
    mkdir -p $out/share
    cp -r . $out/share/

    mkdir -p $out/bin
    makeWrapper $out/share/scala $out/bin/scala

    mkdir -p $out/lib
    mv $out/share/libgtkada.so.2.24.4 $out/lib/
  '';

  meta = with lib;
    with raccoonlib; {
      description =
        "Music software for experimentation with tunings and different kind of scales";
      homepage = "http://www.huygens-fokker.org/scala/";
      license = licenses.unfreeRedistributable;
      platforms = [ "x86_64-linux" ];
      maintainers = [ maintainers.raccoon ];
      mainProgram = "scala";
    };
}

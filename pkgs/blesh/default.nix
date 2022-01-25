{ lib, raccoonlib, stdenv, fetchFromGitHub, writeShellScriptBin }:
stdenv.mkDerivation {
  pname = "blesh";
  version = "0.4.0-git";

  src = fetchFromGitHub {
    owner = "akinomyoga";
    repo = "ble.sh";
    rev = "b4bd955e6ed56d29df389fcc4472b9cbbffc04d0";
    hash = "sha256-LqvUJREKbFVSG4+WXrYnuvXbgIbSDMyr0TPFbMys/I8=";
    fetchSubmodules = true;
  };

  # we're already fetching the submodule, but ble.sh's makefile tries to
  # `git submodule update` anyway. just give it a fake git :)
  nativeBuildInputs = [ (writeShellScriptBin "git" "") ];

  installPhase = ''
    make install INSDIR=$out/share/blesh
  '';

  meta = with lib;
    with raccoonlib; {
      description =
        "A command line editor written in pure Bash scripts which replaces the default GNU Readline.";
      license = licenses.bsd3;
      maintainers = [ maintainers.raccoon ];
    };
}

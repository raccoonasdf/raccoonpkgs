{ pkgs, lib, raccoonlib, fetchFromGitHub, }:
pkgs.rustPlatform.buildRustPackage {
  pname = "jame";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "raccoonasdf";
    repo = "jame";
    rev = "c2519457295c293d30a4ed72c48307085bd7f9f3";
    hash = "sha256-W86kyh06iTsIaPd47Yxmqyw3Z/MgYZ/a4Ip4qPuKpck=";
  };
  cargoHash = "sha256-z/d90JAyyX8V99a1XKnGGhcJ4OMby7StlyLZ64yupVI=";
  meta = with lib;
    with raccoonlib; {
      description = "Our friend jame";
      homepage = "https://github.com/raccoonasdf/jame";
      license = licenses.unfree;
      maintainers = [ maintainers.raccoon ];
    };
}

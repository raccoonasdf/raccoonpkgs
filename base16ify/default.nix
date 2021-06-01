{ pkgs, lib, fetchFromGitHub }:
pkgs.rustPlatform.buildRustPackage {
  pname = "base16ify";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "raccoonasdf";
    repo = "base16ify";
    rev = "338ee2b649fa1586a974a71cb60b5a65cfbba249";
    hash = "sha256-VqAvXgh48taDRfl7Lh7YVvbWRPxdlSdd8yyuHaASkhk=";
  };
  cargoHash = "sha256-T1bHSDcohBBozJgw2LJwLh0GXfWcS40KyAP0B4IVy44=";
  meta = with lib; {
    description = "Modifies 16-color paletted image to match a base16 scheme";
    homepage = "https://github.com/raccoonasdf/base16ify";
    license = licenses.unfree;
    maintainers = with import ../maintainer-list.nix; [ raccoon ];
  };
}

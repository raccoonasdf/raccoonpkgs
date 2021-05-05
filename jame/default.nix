{ pkgs, lib }:
pkgs.rustPlatform.buildRustPackage {
  pname = "jame";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "raccoonasdf";
    repo = "jame";
    rev = "c2519457295c293d30a4ed72c48307085bd7f9f3";
    sha256 = "1jd5ibxshy4aw3d9yq90ydkkfb5bcs6fsy7pd043p29s3p5a9kjv";
  };
  cargoSha256 = "1w02rzghb42kr11bawhay42dfm7941vd0r55k49fqmbw9xp2qgzj";
  meta = with lib; {
    description = "Our friend jame";
    homepage = "https://github.com/raccoonasdf/jame";
    license = licenses.unfree;
  };
}
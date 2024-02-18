{ stdenv, fetchFromGitHub, fetchFromBitbucket }:
let
  mkDokuPlugin = args@{ ... }: stdenv.mkDerivation (args // {
    installPhase = ''
      mkdir -p $out
      cp -R ./* $out/
    '';
  });
in {
  yalist = mkDokuPlugin rec {
    name = "yalist";
    version = "2023-06-30";
    src = fetchFromGitHub {
      owner = "mprins";
      repo = "dokuwiki-plugin-yalist";
      rev = version;
      hash = "sha256-Z+c47C3q6Q8FrFhujavm+g5DmBLRuOgtLUotavOzvlg=";
    };
  };
  wst = mkDokuPlugin {
    name = "wst";
    version = "2018-07-22";
    src = fetchFromBitbucket {
      owner = "vitalie_ciubotaru";
      repo = "wst";
      rev = "10c07a0";
      hash = "sha256-3FI7ZRVTnRKx4cRvOnTXp53DLLQZgeeILl62F5PaCZw=";
    };
  };
  move = mkDokuPlugin {
    name = "move";
    version = "2023-06-28";
    src = fetchFromGitHub {
      owner = "michitux";
      repo = "dokuwiki-plugin-move";
      rev = "8ba3be2";
      hash = "sha256-zgwCQbLHQAXEtDCYTBBFPEEztrGvDkJvsqieKBaUAgk=";
    };
  };
}
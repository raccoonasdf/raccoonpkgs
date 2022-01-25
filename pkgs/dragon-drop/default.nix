{ dragon-drop, fetchFromGitHub }:
dragon-drop.overrideAttrs (old: {
  version = "git";

  src = fetchFromGitHub {
    owner = "mwh";
    repo = "dragon";
    rev = "db7200f689b97d564b59aba55c5a68cab2e45949";
    hash = "sha256-/fcJffhqakT6wLtO1g0/PeD2Nfb94DTHGveygUvpUd8=";
  };
  meta = old.meta // { mainProgram = "dragon"; };
})

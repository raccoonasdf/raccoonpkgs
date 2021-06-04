{ lib, pkgs, ... }:
with lib; {
  base16ify = scheme: src:
    pkgs.stdenv.mkDerivation rec {
      name = "base16ify-" + (baseNameOf (toString src));

      inherit src;

      nativeBuildInputs = [ pkgs.rac.base16ify ];

      dontUnpack = true;
      dontBuild = true;

      installPhase = ''
        base16ify <(echo "${scheme.json}") ${src} $out
      '';
    };

  schemes = mapAttrs (n: v:
    v // {
      hashed = mapAttrs (n: v: "#" + v) v;
      hexed = mapAttrs (n: v: "0x" + v) v;
      json =
        replaceStrings [ ":" "," "}" ] [ ": '" "', " "'}" ] (builtins.toJSON v);
    }) (import ./schemes.nix);
}

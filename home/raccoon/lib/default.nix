{ lib, pkgs, raccoonpkgs, ... }:
with lib; {
  base16ify = scheme: src:
    pkgs.runCommand "base16ify-${baseNameOf (toString src)}" {
      nativeBuildInputs = [ raccoonpkgs.base16ify ];
    } ''base16ify <(echo "${scheme.json}") ${src} $out'';

  schemes = mapAttrs (n: v:
    v // {
      hashed = mapAttrs (n: v: "#" + v) v;
      hexed = mapAttrs (n: v: "0x" + v) v;
      json =
        replaceStrings [ ":" "," "}" ] [ ": '" "', " "'}" ] (builtins.toJSON v);
    }) (import ./schemes.nix);
}

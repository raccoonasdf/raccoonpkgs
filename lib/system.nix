{ lib, ... }: rec {
  systems = [ "x86_64-linux" ];

  forAllSystems = f: lib.genAttrs systems (system: f system);
}
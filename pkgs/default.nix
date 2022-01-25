raccoonlib: final: prev: {
  rac = let
    # this is silly. how to not?
    callPackage = prev.lib.callPackageWith (prev // { inherit raccoonlib; });
  in rec {
    base16ify = callPackage ./base16ify { };

    blesh_0_3 = callPackage ./blesh/0_3.nix { };
    blesh_0_4 = callPackage ./blesh/0_4.nix { };
    blesh = blesh_0_3;
    
    dejsonlz4 = callPackage ./dejsonlz4 { };
    dragon-drop = callPackage ./dragon-drop { };

    fuzzball = callPackage ./fuzzball { };

    grafx2 = callPackage ./grafx2 { };

    jame = callPackage ./jame { };
    vscode-extensions =
      prev.recurseIntoAttrs (callPackage ./vscode-extensions { });
    racmenu = callPackage ./racmenu { };
    racscrot = callPackage ./racscrot { };

    scala-music = callPackage ./scala-music { };

    raccoon-install-tools = callPackage ./raccoon-install-tools { };
  };
}

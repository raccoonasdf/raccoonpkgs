raccoonlib: final: prev: {
  rac = let
    # this is silly. how to not?
    callPackage = prev.lib.callPackageWith (prev // { inherit raccoonlib; });
  in rec {
    base16ify = callPackage ./base16ify { };
    blesh = callPackage ./blesh { };
    
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

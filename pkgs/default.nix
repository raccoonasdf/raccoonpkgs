rac-lib: final: prev: {
  rac = let
    # this is silly. how to not?
    callPackage = prev.lib.callPackageWith (prev // { inherit rac-lib; });
  in rec {
    base16ify = callPackage ./base16ify { };

    blesh_0_3 = callPackage ./blesh/0_3.nix { };
    blesh_0_4 = callPackage ./blesh/0_4.nix { };
    blesh = blesh_0_3;

    jame = callPackage ./jame { };
    vscode-extensions = callPackage ./vscode-extensions { };
    racmenu = callPackage ./racmenu { };
    racscrot = callPackage ./racscrot { };

    raccoon-install-tools = callPackage ./raccoon-install-tools { };
  };
}

final: prev: {
  rac = rec {
    base16ify = prev.callPackage ./base16ify { };

    blesh_0_3 = prev.callPackage ./blesh/0_3.nix { };
    blesh_0_4 = prev.callPackage ./blesh/0_4.nix { };
    blesh = blesh_0_3;

    jame = prev.callPackage ./jame { };
    vscode-extensions = prev.callPackage ./vscode-extensions { };
    racmenu = prev.callPackage ./racmenu { };
    racscrot = prev.callPackage ./racscrot { };

    raccoon-install-tools = prev.callPackage ./raccoon-install-tools { };
  };
}

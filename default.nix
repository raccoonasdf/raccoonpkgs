final: prev: {
  rac = {
    base16ify = prev.callPackage ./base16ify {};
    jame = prev.callPackage ./jame {};
    vscode-extensions = prev.callPackage ./vscode-extensions {};
    racmenu = prev.callPackage ./racmenu {};
    racscrot = prev.callPackage ./racscrot {};
  };
}
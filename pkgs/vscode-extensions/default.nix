{ lib, rac-lib, vscode-utils }:
let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  maintainers = [ rac-lib.maintainers.raccoon ];
in {
  christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "path-intellisense";
      publisher = "christian-kohler";
      version = "2.3.0";
      sha256 = "sha256-dCxpRvSka2rHR4kI/FCIE1LnDY0i+JwtMTFE9sgc1/M=";
    };

    meta = with lib; {
      description = ''
        Plugin that autocompletes filenames.
      '';
      license = licenses.mit;
      inherit maintainers;
    };
  };

  dawhite.mustache = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "mustache";
      publisher = "dawhite";
      version = "1.1.1";
      sha256 = "sha256-PkymMex1icvDN2Df38EIuV1O9TkMNWP2sGOjl1+xGMk=";
    };

    meta = with lib; {
      description = ''
        Syntax highlighting for mustache.
      '';
      license = licenses.mit;
      inherit maintainers;
    };
  };

  gregoire.dance = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "dance";
      publisher = "gregoire";
      version = "0.4.1";
      sha256 = "sha256-MyZFcx5oZ5yFzekPSkFbHs7HE40dSOfzOg984YA86U8=";
    };

    meta = with lib; {
      description = ''
        Provides Kakoune-inspired commands and key bindings for Visual Studio Code.
      '';
      license = licenses.isc;
      inherit maintainers;
    };
  };
}

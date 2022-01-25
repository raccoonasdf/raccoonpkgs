{ pkgs, raccoonpkgs, config, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      with raccoonpkgs.vscode-extensions; [
        # general
        gregoire.dance
        editorconfig.editorconfig
        usernamehw.errorlens
        donjayamanne.githistory
        codezombiech.gitignore
        emmanuelbeziat.vscode-great-icons
        ms-vsliveshare.vsliveshare
        christian-kohler.path-intellisense
        esbenp.prettier-vscode
        gruntfuggly.todo-tree

        # language support
        serayuzgur.crates
        dhall.dhall-lang
        tamasfe.even-better-toml
        yzhang.markdown-all-in-one
        dawhite.mustache
        bbenoist.nix
        ms-python.python
        matklad.rust-analyzer
        timonwong.shellcheck
      ];
    userSettings = {
      "editor.fontFamily" = config.raccoon.styles.fonts.mono;
      "dance.modes" = {
        normal = {
          lineNumbers = "on";
          cursorStyle = "block";
          selectionBehaviour = "character";
        };
      };
    } // (import ./theme.nix) config.raccoon.styles.colors.hashed;
  };
}

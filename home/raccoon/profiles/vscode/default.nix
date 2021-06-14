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
        bbenoist.Nix
        ms-python.python
        matklad.rust-analyzer
        timonwong.shellcheck
      ];
    userSettings = {
      "editor.fontFamily" = config.raccoon.styles.fonts.mono;
    } // (import ./theme.nix) config.raccoon.styles.colors.hashed;
  };
}

{ pkgs, config, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions;
      with pkgs.rac.vscode-extensions; [
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
    userSettings = (import ./theme.nix) config.raccoon.styles.colors.hashed;
  };
}

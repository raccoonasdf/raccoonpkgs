{ lib, config, ... }: {
  programs.emacs = {
    enable = true;
    extraPackages = emacsPackages:
      with emacsPackages; [
        ace-window
        avy
        anzu
        base16-theme
        browse-kill-ring
        crux
        discover-my-major
        diff-hl
        diminish
        easy-kill
        editorconfig
        exec-path-from-shell
        expand-region
        flycheck
        git-timemachine
        guru-mode
        hl-todo
        imenu-anywhere
        projectile
        magit
        move-text
        rg
        smartparens
        smartrep
        undo-tree
        volatile-highlights
        which-key
        zop-to-char

        # languages
        # auctex
        cmake-mode
        csv-mode
        elixir-mode
        gitconfig-mode
        gitignore-mode
        go-mode
        haskell-mode
        jdee
        julia-mode
        json-mode
        lua-mode
        markdown-mode
        nix-mode
        rust-mode
        tuareg
        yaml-mode
      ];
  };

  xdg.configFile."emacs/init.el".source = ./init.el;

  xdg.configFile."emacs/modules".source = ./modules;

  xdg.configFile."emacs/themes/base16-raccoon-theme.el".text = let
    colors = builtins.concatStringsSep "\n" (lib.mapAttrsToList
      (n: v: '':base${lib.toUpper (builtins.substring 4 2 n)} "${v}"'')
      config.raccoon.styles.colors.hashed);
  in ''
    (require 'base16-theme)

    (defvar base16-raccoon-colors
      '(
    ${colors}
      )
      "All colors for raccoon's Base16 theme are defined here.")

    (deftheme base16-raccoon)

    (base16-theme-define 'base16-raccoon base16-raccoon-colors)

    (provide-theme 'base16-raccoon)

    (provide 'base16-raccoon-theme)
  '';
}

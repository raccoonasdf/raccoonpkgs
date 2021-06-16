;; all this shit is stolen from Prelude (github.com/bbatsov/Prelude)
;; i didn't just use Prelude because i wanted to look at everything it was doing
;; this is a work in progress

(setq load-prefer-newer t)

(setq gc-cons-threshold (* 1024 1024 32))

(setq large-file-warning-threshold (* 1024 1024 64))

(require 'crux)

(require 'xdg)

(setq config-dir (file-name-directory load-file-name))
(add-to-list 'load-path (expand-file-name "modules" config-dir))
(add-to-list 'custom-theme-load-path (expand-file-name "themes" config-dir))

(require 'raccoon-keybindings)


(setq data-dir (expand-file-name "emacs" (xdg-data-home)))
(setq gamegrid-user-score-file-directory (expand-file-name "games" data-dir))

(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))

(blink-cursor-mode -1)

(setq ring-bell-function 'ignore)

(setq inhibit-startup-screen t)

(setq scroll-margin 0
      scroll-conservatively 1
      scroll-preserve-screen-position 1)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq require-final-newline t)

(global-auto-revert-mode t)


(setq hippie-expand-try-functions-list '(
  try-expand-dabbrev
  try-expand-dabbrev-all-buffers
  try-expand-dabbrev-from-kill
  try-complete-file-name-partially
  try-complete-file-name
  try-expand-all-abbrevs
  try-expand-list
  try-expand-line
  try-complete-lisp-symbol-partially
  try-complete-lisp-symbol))


(require 'diminish)


(delete-selection-mode t)

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(global-display-line-numbers-mode)

(fset 'yes-or-no-p 'y-or-n-p)

(load-theme 'base16-raccoon t)

(setq tab-always-indent 'complete)


(require 'smartparens-config)

(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(show-smartparens-global-mode +1)

(setq blink-matching-paren nil)


(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")


(setq save-place-file (expand-file-name "places" data-dir))
(save-place-mode 1)


(require 'savehist)
(setq 
  savehist-additional-variables '(search-ring regexp-search-ring)
  savehist-autosave-interval 60
  savehist-file (expand-file-name "savehist" data-dir))
(savehist-mode +1)


(require 'recentf)
(setq
  recentf-save-file (expand-file-name "recentf" data-dir)
  recentf-max-saved-items 128
  recentf-max-menu-items 16
  recentf-auto-cleanup 'never)

(recentf-mode +1)


(require 'windmove)
(windmove-default-keybindings)


(global-hl-line-mode +1)


(require 'volatile-highlights)
(volatile-highlights-mode t)
(diminish 'volatile-highlights-mode)


(require 'rect)
(crux-with-region-or-line kill-region)


(require 'tramp)
(setq tramp-default-method "ssh")


(set-default 'imenu-auto-rescan t)


(add-hook 'before-save-hook 'whitespace-cleanup)


(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(put 'erase-buffer 'disabled nil)


(require 'expand-region)


(require 'bookmark)
(setq
  bookmark-default-file (expand-file-name "bookmarks" data-dir)
  bookmark-save-flag 1)


(require 'projectile)
(setq projectile-cache-file (expand-file-name "projectile.cache" data-dir))
(setq projectile-known-projects-file (expand-file-name "projectile-bookmarks.eld"))
(projectile-mode t)


(require 'avy)
(setq
  avy-background t
  avy-style 'at-full)


(require 'anzu)
(diminish 'anzu-mode)
(global-anzu-mode)

(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)


(put 'dired-find-alternate-file 'disabled nil)
(setq
  dired-recursive-deletes 'always
  dired-recursive-copies 'always
  dired-dwim-target t)

(require 'dired-x)


(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


(require 'midnight)


(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)
(global-set-key (kbd "s-y") 'browse-kill-ring)


(require 'tabify)
(defmacro with-region-or-buffer (func)
  "When called with no active region, call FUNC on current buffer."
  `(defadvice ,func (before with-region-or-buffer activate compile)
     (interactive
      (if mark-active
          (list (region-beginning) (region-end))
        (list (point-min) (point-max))))))

(with-region-or-buffer indent-region)
(with-region-or-buffer untabify)


(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)


(require 'whitespace)
(setq whitespace-style '(face tabs empty trailing lines-tail))
(global-whitespace-mode +1)


(require 're-builder)
(setq reb-re-syntax 'string)


(require 'eshell)
(setq eshell-directory-name (expand-file-name "eshell" data-dir))


(setq semanticdb-default-save-directory (expand-file-name "semanticdb" data-dir))


(require 'undo-tree)
(setq
  undo-tree-history-directory-alist `((".*" . ,temporary-file-directory))
  undo-tree-auto-save-history t)
(global-undo-tree-mode)
(diminish 'undo-tree-mode)


(winner-mode +1)


(global-diff-hl-mode +1)
(add-hook 'dired-mode-hook 'diff-hl-dired-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)


(global-set-key [remap kill-ring-save] 'easy-kill)
(global-set-key [remap mark-sexp] 'easy-mark)


(require 'editorconfig)
(editorconfig-mode 1)
(diminish 'editorconfig-mode)


(require 'exec-path-from-shell)
(exec-path-from-shell-initialize)


(require 'which-key)
(which-key-mode +1)


(setq auto-save-default nil)


(setq frame-title-format '("" invocation-name ": " (:eval
  (if (buffer-file-name)
    (abbreviate-file-name (buffer-file-name))
    "%b"))))


(require 'raccoon-prog)
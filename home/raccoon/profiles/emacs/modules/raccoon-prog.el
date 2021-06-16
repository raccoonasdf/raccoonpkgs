(defun prelude-local-comment-auto-fill ()
  (set (make-local-variable 'comment-auto-fill-only-comments) t))

(require 'which-func)
(which-function-mode 1)

(require 'hl-todo)
(global-hl-todo-mode 1)


(sp-pair "{" nil :post-handlers
         '(((lambda (&rest _ignored)
              (crux-smart-open-line-above)) "RET")))

(setq guru-warn-only t)

(defun prelude-prog-mode-defaults ()
  "Default coding hook, useful with any programming language."
  (guru-mode +1)
  (diminish 'guru-mode)
  (smartparens-mode +1)
  (prelude-local-comment-auto-fill))

(setq prelude-prog-mode-hook 'prelude-prog-mode-defaults)

(add-hook 'prog-mode-hook (lambda ()
                            (run-hooks 'prelude-prog-mode-hook)))

(if (fboundp 'global-flycheck-mode)
    (global-flycheck-mode +1)
  (add-hook 'prog-mode-hook 'flycheck-mode))

(provide 'raccoon-prog)

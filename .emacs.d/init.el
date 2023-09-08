;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)


;; Install use-package if it's not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load use-package
(eval-when-compile
  (require 'use-package))

;; for powerful julia repl
(use-package vterm
  :ensure t)

;; julia-mode
(use-package julia-mode
  :ensure t)

(use-package julia-repl
  :ensure t
  :hook (julia-mode . julia-repl-mode)
  :init (setenv "JULIA_HUM_THREADS" "8")
  :config
  ;; Set the terminal backend
  (julia-repl-set-terminal-backend 'vterm)
  
  ;; Keybeindings for quickly sending code to the REPL
  (define-key julia-repl-mode-map (kbd "C-RET") 'my/julia-repl-send-cell)
                                  (kbd "M-RET") 'julia-repl-send-line)
                                  (kbd "S-RET") 'julia-repl-send-buffer)))

;; start buffer using C-c C-z
;; vterm backend gives fully featured Julia REPL

(defun my/julia-repl-send-cell ()
  ;; "Send the current julia cell (delimted by ###) to the julia shell"
  (interactive)
  (save-excursion (setq cell-begin (if (re-search-backward "^###" nil t) (point) (point-min))))
  (save-excursion (setq cell-end (if (re-search-forward "^###" nil t) (point) (point-max))))
  (set-mark cell-begin)
  (goto-char cell-end)
  (julia-repl-send-region-or-line)
  (next-line))

;; IDE-like features using language server protocol

(quelpa '(lsp-julia :fetcher github
           :repo "non-jedi/lsp-julia"
           :files (:defaults "languageserver")))

(use-package lsp-julia
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.6"))

(add-hook 'julia-mode-hook #'lsp-mode)


;; set ORIG_HOME back
(setenv "HOME" (getenv "ORIG_HOME"))


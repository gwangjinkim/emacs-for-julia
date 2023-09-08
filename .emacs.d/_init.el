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

;; Julia Programming
(use-package julia-mode
  :ensure t
  :mode "\\.jl\\'"
  :bind (:map julia-mode-map
              ("C-c C-j" . julia-send-line)
              ("C-c C-c" . julia-send-region)
              ("C-c C-b" . julia-send-buffer)
              ("M-." . xref-find-definitions))
  )

;; (use-package lsp-mode
;;   :ensure t
;;   :hook ((julia-mode . lsp))
;;   :commands (lsp)
;;   :config
;;   ;; Add semgrep-ls to the list of available servers
;;   (require 'lsp-clients)
;;   (lsp-register-client
;;     (make-lsp-client :new-connection (lsp-stdio-connection '("semgrep" "--lsp"))
;;                      :major-modes '(julia-mode)
;;                      :server-id 'semgrep-ls))
;;   ;; Customize other lsp-mode settings here
;; )

(use-package julia-repl
  :ensure t)

;; LSP (Language Server Protocol) for Julia
(use-package lsp-julia
  :ensure t
  :hook (julia-mode . lsp)
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.6")) ;; Set your Julia environment path

;; Company for code completion
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0))

;; Snippet support with yasnippet
(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode))

;; Enable MELPA
(setq package-enable-at-startup nil)

;; set ORIG_HOME back
(setenv "HOME" (getenv "ORIG_HOME"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(yasnippet company lsp-julia julia-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

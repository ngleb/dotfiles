(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(defconst my-base-dir
  (file-name-as-directory
   (expand-file-name user-login-name "C:/Users")))

(setq default-directory my-base-dir)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(load (expand-file-name "init-ledger" user-emacs-directory))

(bind-keys
 ("<f1>" . ibuffer)
 ("C-x C-b" . ibuffer)
 ("<f10>" . save-buffer))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(blink-cursor-mode -1)
(show-paren-mode 1)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-emacs 'y-or-n-p)
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; MULE & encoding setup
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(setq default-input-method "russian-computer")

;; Window size & position; font settings
(add-to-list 'default-frame-alist '(width  . 120))
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(top . 5))
(add-to-list 'default-frame-alist '(left . 5))
(add-to-list 'default-frame-alist '(font . "Consolas 11"))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(defconst my-backup-dir
  (expand-file-name "Backup" my-base-dir))
(setq backup-directory-alist `(("." . ,my-backup-dir)))
(setq make-backup-files t
      backup-by-copying t
      version-control t
      delete-old-versions t
      delete-by-moving-to-trash t
      kept-old-versions 6
      kept-new-versions 9
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 200)

(use-package company
  :bind (("C-<tab>" . company-complete-common-or-cycle)
	 ("C-M-i" . company-complete-common-or-cycle))
  :init
  (setq company-require-match nil)
  (setq company-idle-delay 0.5)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-flip-when-above t)
  :config
  (add-hook 'prog-mode-hook 'global-company-mode))

(use-package counsel
  :after ivy
  :demand t
  :bind (("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c j" . counsel-imenu)
	 ("C-x r b" . counsel-bookmark)))
  
(use-package flycheck
  :defer 5)

(use-package ivy
  :demand t
  :bind ("C-c C-r" . ivy-resume)
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-display-style 'fancy)
  (ivy-count-format "(%d/%d) ")
  (ivy-initial-inputs-alist nil)
  (ivy-do-completion-in-region nil)
  :config
  (ivy-mode 1))

(use-package monokai-theme
  :config
  (load-theme 'monokai t))

(use-package smooth-scrolling
  :config
  (setq smooth-scroll-margin 5)
  (smooth-scrolling-mode 1))

(use-package swiper
  :after ivy
  :commands swiper
  :bind (("C-s" . swiper)
	 :map read-expression-map
	 ("C-r" . counsel-expression-history)))

(find-file (expand-file-name "Nextcloud/Finance/accounts.ledger" my-base-dir))
(find-file (expand-file-name "Nextcloud/Finance/commands.org" my-base-dir))
(find-file (expand-file-name "Nextcloud/Finance/home.ledger" my-base-dir))

;;; init.el ends here

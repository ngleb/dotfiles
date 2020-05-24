(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
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

(bind-keys
 ("<f1>" . ibuffer)
 ("C-x C-b" . ibuffer)
 ("<f10>" . save-buffer)
 ("<f4>" . end-of-buffer))

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

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
      scroll-conservatively most-positive-fixnum
      scroll-preserve-screen-position t
      scroll-margin 0
      hscroll-margin 1
      hscroll-step 1)

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

(setq calendar-week-start-day 1)

(use-package company
  :diminish " ❋"
  :bind(:map company-mode-map
        ("TAB" . company-indent-or-complete-common)
        :map company-active-map
        ("TAB" . company-complete-common-or-cycle)
        ("<tab>" . company-complete-common-or-cycle))
  :init
  (add-hook 'prog-mode-hook 'company-mode)
  :config
  (setq company-require-match nil
        company-show-numbers t
        company-minimum-prefix-length 2
        company-idle-delay 0.1))

(use-package flycheck)

(use-package ivy
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-display-style 'fancy)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-do-completion-in-region nil)
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
	     ("C-c j" . counsel-imenu)
         ("C-x r b" . counsel-bookmark))
  :config
  (setq ivy-initial-inputs-alist nil))

(use-package swiper
  :after ivy
  :commands swiper-isearch
  :bind (("C-s" . swiper-backward)
         ("<f3>" . swiper-backward)))

(use-package monokai-theme
  :config
  (load-theme 'monokai t))

(load (expand-file-name "init-ledger" user-emacs-directory))

(add-hook 'emacs-startup-hook
          (lambda ()
            (find-file (expand-file-name "Nextcloud/Finance/accounts.ledger" my-base-dir))
            (find-file (expand-file-name "Nextcloud/Finance/commands.org" my-base-dir))
            (find-file (expand-file-name "Nextcloud/Finance/home.ledger" my-base-dir))
            (end-of-buffer)))

;;; init.el ends here

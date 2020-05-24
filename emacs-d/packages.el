(package-initialize)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-refresh-contents)

(defconst ora-packages
  '(company
    counsel
    diminish
    flycheck
    flycheck-ledger
    hydra
    ivy
    ledger-mode
    monokai-theme
    smooth-scrolling
    swiper
    use-package
    which-key)
  "List of packages that I like.")

;; install required
(dolist (package ora-packages)
  (unless (package-installed-p package)
    (ignore-errors
      (package-install package))))

;; upgrade installed
(save-window-excursion
  (package-list-packages t)
  (package-menu-mark-upgrades)
  (condition-case nil
      (package-menu-execute t)
    (error
     (package-menu-execute))))

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa"  . "https://stable.elpa.gnu.org/packages/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package evil
  :init
  :config
  (evil-mode 1))

(use-package fzf
  :config
  (setq fzf/args "--layout=default -x --color bw --print-query --margin=1,0 --no-hscroll"))

(evil-define-key 'normal 'global
  (kbd "SPC SPC") 'fzf-find-file
  (kbd "SPC ,") 'fzf-switch-buffer
  (kbd "SPC /") 'fzf-grep-project
  (kbd "SPC fg") 'fzf-git-files)

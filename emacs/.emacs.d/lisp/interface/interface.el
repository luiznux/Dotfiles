;;; interface.el --- visual beauties for Emacs
;;; Commentary:
;;; Visual beauties for you code more happier :)
;;;
;;;       ⣿⣷⡶⠚⠉⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠠⣴⣿⣿⣿⣿⣶⣤⣤⣤
;;;       ⠿⠥⢶⡏⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢀⣴⣷⣌⢿⣿⣿⣿⣿⣿⣿⣿
;;;       ⣍⡛⢷⣠⣿⣿⣿⣿⣿⣟⠻⣯⠽⣿⣿⠟⠁⣠⠿⠿⣿⣿⣎⠻⣿⣿⣿⡿⠟⣿
;;;       ⣿⣿⣦⠙⣿⣿⣿⣿⣿⣿⣷⣏⡧⠙⠁⣀⢾⣧    ⠈⣿⡟  ⠙⣫⣵⣶⠇⣋
;;;       ⣿⣿⣿⢀⣿⣿⣿⣿⣿⣿⣿⠟⠃⢀⣀⢻⣎⢻⣷⣤⣴⠟  ⣠⣾⣿⢟⣵⡆⢿
;;;       ⣿⣯⣄⢘⢻⣿⣿⣿⣿⡟⠁⢀⣤⡙⢿⣴⣿⣷⡉⠉⢀  ⣴⣿⡿⣡⣿⣿⡿⢆
;;;       ⠿⣿⣧⣤⡘⢿⣿⣿⠏  ⡔⠉⠉⢻⣦⠻⣿⣿⣶⣾⡟⣼⣿⣿⣱⣿⡿⢫⣾⣿
;;;       ⣷⣮⣝⣛⣃⡉⣿⡏  ⣾⣧⡀    ⣿⡇⢘⣿⠋    ⠻⣿⣿⣿⢟⣵⣿⣿⣿
;;;       ⣿⣿⣿⣿⣿⣿⣌⢧⣴⣘⢿⣿⣶⣾⡿⠁⢠⠿⠁⠜    ⣿⣿⣿⣿⡿⣿⣿⣿
;;;       ⣿⣿⣿⣿⣿⣿⣿⣦⡙⣿⣷⣉⡛⠋    ⣰⣾⣦⣤⣤⣤⣿⢿⠟⢋⣴⣿⣿⣿
;;;       ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣌⢿⣿⣿⣿⣿⢰⡿⣻⣿⣿⣿⣿⣿⢃⣰⣫⣾⣿⣿⣿
;;;       ⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⠿⠿⠿⠛⢰⣾⡿⢟⣭⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
;;;
;;; Code:

(defun interface-setup()
  "Call all interface packages."

  (require 'iso-transl)
  (use-package highlight-indent-guides
    :config
    (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
    (setq highlight-indent-guides-method 'character)
    (setq highlight-indent-guides-responsive 'top))

  (use-package highlight-symbol
    :bind
    (:map prog-mode-map
          ("M-o h" . highlight-symbol)
          ("M-p" . highlight-symbol-prev)
          ("M-n" . highlight-symbol-next)))

  (use-package which-key
    :config
    (which-key-mode))

  ;;  (use-package smex
  ;;    :config
  ;;    (global-set-key (kbd "M-x") 'smex))

  ;; Add icons for emacs
  (use-package all-the-icons)

  (use-package ibuffer
    :ensure nil
    :bind ("C-x C-b" . ibuffer)
    :init (setq ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold)))
    :config
    ;; Display icons for buffers
    (use-package all-the-icons-ibuffer
      :init (all-the-icons-ibuffer-mode 1)
      :config

      (with-eval-after-load 'counsel
        (with-no-warnings
          (defun my-ibuffer-find-file ()
            (interactive)
            (let ((default-directory (let ((buf (ibuffer-current-buffer)))
                                       (if (buffer-live-p buf)
                                           (with-current-buffer buf
                                             default-directory)
                                         default-directory))))
              (counsel-find-file default-directory)))
          (advice-add #'ibuffer-find-file :override #'my-ibuffer-find-file)))))

  ;; Group ibuffer's list by project root
  (use-package ibuffer-projectile
    :functions all-the-icons-octicon ibuffer-do-sort-by-alphabetic
    :hook ((ibuffer . (lambda ()
                        (ibuffer-projectile-set-filter-groups)
                        (unless (eq ibuffer-sorting-mode 'alphabetic)
                          (ibuffer-do-sort-by-alphabetic))))))

  (use-package emojify
    :config
    (setq emojify-company-tooltips-p t
          emojify-composed-text-p    nil)
    :hook (after-init . global-emojify-mode))

  (use-package rainbow-mode
    :hook (emacs-lisp-mode . rainbow-mode))

  (use-package dashboard
    :init
    (progn
      (setq recentf-exclude '("/org/*")) ;prevent  show recent org-agenda files
      (setq dashboard-items '((recents   . 8)
                              (projects  .  7))))
    :config
    (dashboard-setup-startup-hook)

    (setq dashboard-set-heading-icons  t
          dashboard-set-file-icons     t
          dashboard-set-navigator      t
          dashboard-startup-banner     'logo)

    (setq dashboard-navigator-buttons
          `(;;line1
            ((,(all-the-icons-octicon "mark-github" :height 1.1 :v-adjust 0.0)
              "Homepage"
              "Browse homepage"
              (lambda (&rest _) (browse-url "https://github.com/luiznux")))
             (" " "Refresh" "Refresh" (lambda (&rest _) (dashboard-refresh-buffer)) nil))))

    (add-hook 'dashboard-mode-hook (lambda () (org-agenda t "x")) (lambda () (ace-window)))
    (add-hook 'dashboard-mode-hook (lambda () (goto-char (point-min)))))

  (use-package centaur-tabs
    :config
    (setq centaur-tabs-style                    "chamfer"
          centaur-tabs-height                   32
          centaur-tabs-set-icons                t
          centaur-tabs-set-bar                  'under
          x-underline-at-descent-line           t
          centaur-tabs-set-modified-marker      t
          centaur-tabs-show-navigation-buttons  t)

    (centaur-tabs-headline-match)
    (centaur-tabs-group-by-projectile-project)
    (centaur-tabs-mode t)
    (centaur-tabs-change-fonts "Source Code Pro" 102)
    (defun centaur-tabs-buffer-groups ()
      "`centaur-tabs-buffer-groups' control buffers' group rules.
 Group centaur-tabs with mode if buffer is derived from `eshell-mode' `emacs-lisp-mode' `dired-mode' `org-mode' `magit-mode'.
 All buffer name start with * will group to \"Emacs\".
 Other buffer group by `centaur-tabs-get-group-name' with project name."
      (list
       (cond
        ((or (string-equal "*" (substring (buffer-name) 0 1))
             (memq major-mode '(magit-process-mode
                                magit-status-mode
                                magit-diff-mode
                                magit-log-mode
                                magit-file-mode
                                magit-blob-mode
                                magit-blame-mode
                                )))
         "Emacs")
        ((derived-mode-p 'prog-mode)
         "Editing")
        ((derived-mode-p 'emacs-lisp-mode)
         "Elisp")
        ((derived-mode-p 'dired-mode)
         "Dired")
        ((memq major-mode '(helpful-mode
                            help-mode))
         "Help")
        ((memq major-mode '(org-mode
                            org-agenda-clockreport-mode
                            org-src-mode
                            org-agenda-mode
                            org-beamer-mode
                            org-indent-mode
                            org-bullets-mode
                            org-cdlatex-mode
                            org-agenda-log-mode
                            diary-mode))
         "OrgMode")
        (t
         (centaur-tabs-get-group-name (current-buffer))))))
    :hook
    (dashboard-mode . centaur-tabs-local-mode)
    (term-mode . centaur-tabs-local-mode)
    (calendar-mode . centaur-tabs-local-mode)
    (org-agenda-mode . centaur-tabs-local-mode)
    (helpful-mode . centaur-tabs-local-mode)
    :bind
    ("C-<prior>" . centaur-tabs-backward)
    ("C-<next>" . centaur-tabs-forward)
    ("C-c t" . centaur-tabs-counsel-switch-group)
    (:map evil-normal-state-map
          ("g t" . centaur-tabs-forward)
          ("g T" . centaur-tabs-backward)))

  (use-package pdf-view
    :ensure pdf-tools
    :diminish (pdf-view-midnight-minor-mode pdf-view-printer-minor-mode)
    :defines pdf-annot-activate-created-annotations
    :functions (my-pdf-view-set-midnight-colors my-pdf-view-set-dark-theme)
    :hook (pdf-view-mode . pdf-view-midnight-minor-mode)
    :mode ("\\.[pP][dD][fF]\\'" . pdf-view-mode)
    :magic ("%PDF" . pdf-view-mode)
    :bind (:map pdf-view-mode-map
                ("C-s" . isearch-forward))
    :init
    (setq pdf-annot-activate-created-annotations t)

    ;; Set dark theme
    (defun my-pdf-view-set-midnight-colors ()
      "Set pdf-view midnight colors."
      (setq pdf-view-midnight-colors
            `(,(face-foreground 'default) . ,(face-background 'default))))
    (my-pdf-view-set-midnight-colors)

    (defun my-pdf-view-set-dark-theme ()
      "Set pdf-view midnight theme as color theme."
      (my-pdf-view-set-midnight-colors)
      (dolist (buf (buffer-list))
        (with-current-buffer buf
          (when (eq major-mode 'pdf-view-mode)
            (pdf-view-midnight-minor-mode (if pdf-view-midnight-minor-mode 1 -1))))))
    (add-hook 'after-load-theme-hook #'my-pdf-view-set-dark-theme)
    :config
    ;; Build pdfinfo if needed, locking until it's complete
    (with-no-warnings
      (defun my-pdf-tools-install ()
        (unless (file-executable-p pdf-info-epdfinfo-program)
          (let ((wconf (current-window-configuration)))
            (pdf-tools-install t)
            (message "Building epdfinfo. Please wait for a moment...")
            (while compilation-in-progress
              ;; Block until `pdf-tools-install' is done
              (sleep-for 1))
            (when (file-executable-p pdf-info-epdfinfo-program)
              (set-window-configuration wconf)))))
      (advice-add #'pdf-view-decrypt-document :before #'my-pdf-tools-install)))

  (use-package parrot
    :config
    (parrot-mode)
    (parrot-set-parrot-type 'emacs)
    (setq parrot-num-rotations 6)
    (add-hook 'evil-insert-state-entry-hook #'parrot-start-animation)
    (add-hook 'evil-visual-state-entry-hook #'parrot-start-animation)
    (add-hook 'evil-emacs-state-entry-hook  #'parrot-start-animation))

  (use-package ranger
    :config
    (ranger-override-dired-mode t))

  (use-package hide-mode-line
    :hook (((completion-list-mode
             completion-in-region-mode
             pdf-annot-list-mode
             flycheck-error-list-mode
             vterm-mode
             ido-mode
             lsp-treemacs-error-list-mode) . hide-mode-line-mode)))

  (use-package google-translate
    :bind
    ("M-o t" . google-translate-at-point)
    ("M-o T" . google-translate-at-point-reverse)
    :custom
    (google-translate-default-source-language "en")
    (google-translate-default-target-language "ja"))

  ;; Enforce rules for popups
  (use-package shackle
    :functions org-switch-to-buffer-other-window
    :commands shackle-display-buffer
    :hook (after-init . shackle-mode)
    :config
    (with-no-warnings
      (defvar shackle--popup-window-list nil) ; all popup windows
      (defvar-local shackle--current-popup-window nil) ; current popup window
      (put 'shackle--current-popup-window 'permanent-local t)

      (defun shackle-last-popup-buffer ()
        "View last popup buffer."
        (interactive)
        (ignore-errors
          (display-buffer shackle-last-buffer)))
      (bind-key "C-h z" #'shackle-last-popup-buffer)

      ;; Add keyword: `autoclose'
      (defun shackle-display-buffer-hack (fn buffer alist plist)
        (let ((window (funcall fn buffer alist plist)))
          (setq shackle--current-popup-window window)

          (when (plist-get plist :autoclose)
            (push (cons window buffer) shackle--popup-window-list))
          window))

      (defun shackle-close-popup-window-hack (&rest _)
        "Close current popup window via `C-g'."
        (setq shackle--popup-window-list
              (cl-loop for (window . buffer) in shackle--popup-window-list
                       if (and (window-live-p window)
                               (equal (window-buffer window) buffer))
                       collect (cons window buffer)))
        ;; `C-g' can deactivate region
        (when (and (called-interactively-p 'interactive)
                   (not (region-active-p)))
          (let (window buffer process)
            (if (one-window-p)
                (progn
                  (setq window (selected-window))
                  (when (equal (buffer-local-value 'shackle--current-popup-window
                                                   (window-buffer window))
                               window)
                    (winner-undo)))
              (progn
                (setq window (caar shackle--popup-window-list))
                (setq buffer (cdar shackle--popup-window-list))
                (when (and (window-live-p window)
                           (equal (window-buffer window) buffer))
                  (setq process (get-buffer-process buffer))
                  (when (process-live-p process)
                    (kill-process process))
                  (delete-window window)

                  (pop shackle--popup-window-list)))))))

      (advice-add #'keyboard-quit :before #'shackle-close-popup-window-hack)
      (advice-add #'shackle-display-buffer :around #'shackle-display-buffer-hack))

    ;; HACK: compatibility issue with `org-switch-to-buffer-other-window'
    (advice-add #'org-switch-to-buffer-other-window :override #'switch-to-buffer-other-window)

    ;; rules
    (setq shackle-default-size 0.4
          shackle-default-alignment 'below
          shackle-default-rule nil
          shackle-rules
          '((("*Help*" "*Apropos*") :select t :size 0.3 :align 'below :autoclose t)
            (("*Directory*") :select t :size 0.1 :align 'below :autoclose t)
            (compilation-mode :select t :size 0.3 :align 'below :autoclose t)
            (comint-mode :select t :size 0.4 :align 'below :autoclose t)
            ("*Completions*" :size 0.3 :align 'below :autoclose t)
            ("*Pp Eval Output*" :size 15 :align 'below :autoclose t)
            ("*Backtrace*" :select t :size 15 :align 'below)
            ("^\\*.*Shell Command.*\\*$" :regexp t :size 0.3 :align 'below :autoclose t)
            ("\\*[Wo]*Man.*\\*" :regexp t :select t :align 'below :autoclose t)
            ("*Calendar*" :select t :size 0.3 :align 'below)
            (("*shell*" "*eshell*" "*ielm*") :popup t :size 0.3 :align 'below)
            ("^\\*vc-.*\\*$" :regexp t :size 0.3 :align 'below :autoclose t)
            ("*gud-debug*" :select t :size 0.4 :align 'below :autoclose t)
            ("\\*ivy-occur .*\\*" :regexp t :select t :size 0.3 :align 'below)
            (" *undo-tree*" :select t)
            ("*quickrun*" :select t :size 15 :align 'below)
            ("*tldr*" :size 0.4 :align 'below :autoclose t)
            ("*osx-dictionary*" :size 20 :align 'below :autoclose t)
            ("*Youdao Dictionary*" :size 15 :align 'below :autoclose t)
            ("*Finder*" :select t :size 0.3 :align 'below :autoclose t)
            ("^\\*macro expansion\\**" :regexp t :size 0.4 :align 'below)
            ("^\\*elfeed-entry" :regexp t :size 0.7 :align 'below :autoclose t)
            (" *Install vterm* " :size 0.35 :same t :align 'below)
            (("*Paradox Report*" "*package update results*") :size 0.2 :align 'below :autoclose t)
            ("*Package-Lint*" :size 0.4 :align 'below :autoclose t)
            ("*How Do You*" :select t :size 0.5 :align 'below :autoclose t)

            (("\\*Capture\\*" "^CAPTURE-.*\\.org*") :regexp t :select t :size 0.3 :align 'below :autoclose t)

            ("*ert*" :size 15 :align 'below :autoclose t)
            (overseer-buffer-mode :size 15 :align 'below :autoclose t)

            (" *Flycheck checkers*" :select t :size 0.3 :align 'below :autoclose t)
            ((flycheck-error-list-mode flymake-diagnostics-buffer-mode)
             :select t :size 0.25 :align 'below :autoclose t)

            (("*lsp-help*" "*lsp session*") :size 0.3 :align 'below :autoclose t)
            ("*DAP Templates*" :select t :size 0.4 :align 'below :autoclose t)
            (dap-server-log-mode :size 15 :align 'below :autoclose t)
            ("*rustfmt*" :select t :size 0.3 :align 'below :autoclose t)
            ((rustic-compilation-mode rustic-cargo-clippy-mode rustic-cargo-outdated-mode rustic-cargo-test-mode) :select t :size 0.3 :align 'below :autoclose t)

            (profiler-report-mode :select t :size 0.5 :align 'below)
            ("*ELP Profiling Restuls*" :select t :size 0.5 :align 'below)

            ((inferior-python-mode inf-ruby-mode swift-repl-mode) :size 0.4 :align 'below)
            ("*prolog*" :size 0.4 :align 'below)

            (("*Gofmt Errors*" "*Go Test*") :select t :size 0.3 :align 'below :autoclose t)
            (godoc-mode :select t :size 0.4 :align 'below :autoclose t)

            ((grep-mode rg-mode deadgrep-mode ag-mode pt-mode) :select t :size 0.4 :align 'below)
            (Buffer-menu-mode :select t :size 20 :align 'below :autoclose t)
            (gnus-article-mode :select t :size 0.7 :align 'below :autoclose t)
            (helpful-mode :select t :size 0.3 :align 'below :autoclose t)
            ((process-menu-mode cargo-process-mode) :select t :size 0.3 :align 'below :autoclose t)
            (list-environment-mode :select t :size 0.3 :align 'below :autoclose t)
            (tabulated-list-mode :size 0.4 :align 'below))))


  (use-package vterm
    :config
    (defun evil-collection-vterm-escape-stay ()
      "Go back to normal state but don't move
cursor backwards. Moving cursor backwards is the default vim behavior but it is
not appropriate in some cases like terminals."
      (setq-local evil-move-cursor-back nil))

    (add-hook 'vterm-mode-hook #'evil-collection-vterm-escape-stay))

  (use-package  multi-vterm
    :after vterm
    :config
	(add-hook 'vterm-mode-hook
			  (lambda ()
			    (setq-local evil-insert-state-cursor 'box)
			    (evil-insert-state)))
	(define-key vterm-mode-map [return]                      #'vterm-send-return)

	(setq vterm-keymap-exceptions nil)
	(evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
	(evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
	(evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	(evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
	(evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
	(evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
	(evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
	(evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
	(evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

  (use-package vterm-toggle
    :after vterm
    :config
    (global-set-key [f2] 'vterm-toggle)
    (global-set-key [C-f2] 'vterm-toggle-cd)
    (define-key vterm-mode-map [(control return)]   #'vterm-toggle-insert-cd)
    (define-key vterm-mode-map (kbd "s-n") 'vterm-toggle-forward) ;Switch to next vterm buffer
    (define-key vterm-mode-map (kbd "s-p") 'vterm-toggle-backward) ;Switch to previous vterm buffer

    (setq vterm-toggle-cd-auto-create-buffer nil)

    (defun myssh()
      (interactive)
      (let ((default-directory "/ssh:root@host:~"))
        (vterm-toggle-cd)))

    (setq vterm-toggle-fullscreen-p nil)
    (add-to-list 'display-buffer-alist
                 '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                   (display-buffer-reuse-window display-buffer-in-side-window)
                   (side . bottom)
                   (dedicated . t) ;dedicated is supported in emacs27
                   (reusable-frames . visible)
                   (window-height . 0.3)))

    (setq centaur-tabs-buffer-groups-function 'vmacs-awesome-tab-buffer-groups)
    (defun vmacs-awesome-tab-buffer-groups ()
      "`vmacs-awesome-tab-buffer-groups' control buffers' group rules. "
      (list
       (cond
        ((derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode)
         "Term")
        ((string-match-p (rx (or
                              "\*Helm"
                              "\*helm"
                              "\*tramp"
                              "\*Completions\*"
                              "\*sdcv\*"
                              "\*Messages\*"
                              "\*Ido Completions\*"
                              ))
                         (buffer-name))
         "Emacs")
        (t "Common"))))

    (setq vterm-toggle--vterm-buffer-p-function 'vmacs-term-mode-p)
    (defun vmacs-term-mode-p(&optional args)
      (derived-mode-p 'eshell-mode 'term-mode 'shell-mode 'vterm-mode)))

  (use-package winner
    :ensure nil
    :commands (winner-undo winner-redo)
    :hook (after-init . winner-mode)
    :init (setq winner-boring-buffers '("*Completions*"
                                        "*Compile-Log*"
                                        "*inferior-lisp*"
                                        "*Fuzzy Completions*"
                                        "*Apropos*"
                                        "*Help*"
                                        "*cvs*"
                                        "*Buffer List*"
                                        "*Ibuffer*"
                                        "*esh command on file*")))

  (use-package latex-preview-pane)

  (use-package math-preview)

  (use-package switch-window)

  (use-package page-break-lines)

  (use-package google-this))


(interface-setup)

(provide 'interface)
;;; interface.el ends here

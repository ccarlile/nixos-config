{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    
    init = {
      enable = true;
      recommendedGcSettings = true;

      prelude = '';;
        ;; Disable some GUI distractions. We set these manually to avoid starting
        ;; the corresponding minor modes.
        (push '(menu-bar-lines . 0) default-frame-alist)
        (push '(tool-bar-lines . nil) default-frame-alist)
        (push '(vertical-scroll-bars . nil) default-frame-alist)
        ;; Set up fonts early.
        (set-face-attribute 'default
        nil
        :font "Hasklig-12")

        (set-face-attribute 'variable-pitch
                            nil
                            :family "Source Sans Pro")

        (setq initial-major-mode 'org-mode)
        (setq-default indent-tabs-mode nil)
        (add-hook 'dired-mode-hook 'auto-revert-mode)
        (setq explicit-shell-file-name 
          (concat (getenv "HOME") "/.nix-profile/bin/zsh"))
        (setq sgml-quick-keys 'close)

        (defun switch-to-scratch-buffer ()
          (interactive)
          (switch-to-buffer "*scratch*"))
      '';

      usePackage = {
        files = {
          enable = true;
          ensureNil = true;
          init = '';;
            (custom-set-variables
              '(backup-by-copying t)
              '(backup-directory-alist '(("." . "~/.saves/")))
              '(delete-old-versions t)
              '(kept-new-versions 6)
              '(kept-old-versions 2)
              '(version-control t))
          '';
        };

        simple = {
          enable = true;
          ensureNil = true;
          init = ''
            (custom-set-variables
              '(column-number-mode t)
              '(global-visual-line-mode t))
          '';
        };

        autorevert = {
          enable = true;
          ensureNil = true;
          init = ''
            (custom-set-variables '(global-auto-revert-mode 1)) 
          '';
          hook = [
            "(dired-mode . auto-revert-mode)"
          ];
        };

        f = {
          enable = true;
        };

        evil = {
          enable = true;
          init = '';;
            (setq evil-search-module 'evil-search)
            (setq evil-ex-complete-emacs-commands nil)
            (setq evil-vsplit-window-right t)
            (setq evil-split-window-below t)
            (setq evil-shift-round nil)
            (setq evil-want-C-u-scroll t) 
            (setq evil-want-Y-yank-to-eol t)
            (setq evil-want-integration nil)
            (setq evil-want-keybinding' nil)
            (setq evil-undo-system 'undo-fu)
            '';
          config = '';;
            (define-key evil-normal-state-map [backspace] 
              'evil-switch-to-windows-last-buffer)
            (evil-set-initial-state 'vterm-mode 'emacs)
            (evil-set-initial-state 'dashboard-mode 'emacs)
            (evil-mode)
            '';
          };

        undo-fu = {
          enable = true;
        };

        which-key = {
          enable = true;
          config = ''
            (which-key-mode)
            (which-key-setup-side-window-bottom)
            (setq which-key-sort-order 'which-key-key-order-alpha
                  which-key-idle-delay 0.01)   
          '';
        };


        # The dilemma here was - put mode-specific keybindings in
        # their respective blocks, or leave them in the general.el
        # monolith? As of right now, the former requires creating a
        # definer which we refer to in other places in the resulting
        # lisp code - i.e. not declarative! So I'll do the latter. God
        # save me.

        general = {
          enable = true;
          after = [ "evil" "which-key" ];
          config = '';;
            (general-evil-setup)

            (general-define-key
              :states 'emacs
              "C-'" (general-simulate-key "SPC" :state 'normal)
              "M-x" 'helm-M-x
              "C-:" 'evil-ex)

            (general-nmap
              ";" 'evil-ex
              ":" 'evil-repeat-find-char)

            (general-nmap
              "C-j" 'evil-window-down
              "C-k" 'evil-window-up
              "C-c l" 'winner-redo
              "C-c h" 'winner-undo
              "C-]" 'dumb-jump-go
              "C-'" 'dumb-jump-go
              "C-t" 'dumb-jump-back
              "j" 'evil-next-visual-line
              "k" 'evil-previous-visual-line
              "C-/" 'evil-avy-goto-char-timer)

            (general-create-definer space-leader-def
              :prefix "SPC")

            (general-create-definer space-leader-mode-def
              :prefix "SPC m")

            (space-leader-mode-def
              :keymaps 'org-mode-map
              :states '(normal visual)
              "t" '(org-sparse-tree :which-key "sparse tree"))

            (space-leader-def
              :states '(normal visual)
              :keymaps 'override

              "SPC" '(helm-M-x :which-key "M-x")
              "m" '(:ignore t :which-key "major mode")

              "g" '(:ignore t :which-key "git")
              "g s" '(magit-status :which-key "magit")
              "g r" '(browse-at-remote :which-key "browse on forge")
              "g b" '(magit-blame :which-key "blame")
              "g f" '(magit-log-buffer-file "log for file")
            
              "b" '(:ignore t :which-key "buffer")
              "b b" '(helm-mini :which-key "list buffers")
              "b s" '(switch-to-scratch-buffer :which-key "scratch")
              "b k" '(kill-buffer :which-key "kill buffer")
              
              "f" '(:ignore t :which-key "files")
              "f f" '(helm-find-files :which-key "find")
              "f j" '(dired-jump :which-key "dired")

              "h" '(:ignore t :which-key "help")
              "h k" '(describe-key :which-key "describe key")
              "h f" '(describe-function :which-key "describe function")
              "h v" '(describe-variable :which-key "describe variable")
              "h i" '(info :which-key "info")
              "h b" '(describe-bindings :which-key "describe bindings")
              "h m" '(describe-mode :which-key "describe mode")
              "h w" '(which-key-show-top-level :which-key "which key top level")

              "p" '(:ignore t :which-key "project")
              "p f" '(helm-projectile-find-file :which-key "find file")
              "p p" '(helm-projectile-switch-project :which-key "switch to project")
              "p i" '(projectile-invalidate-cache :which-key "invalidate project cache")
              "p t" '(projectile-toggle-between-implementation-and-test :which-key "switch between test and src")
              "p s" '(helm-lsp-workspace-symbol :which-key "LSP - xref symbol")

              "l" '(:ignore t :which-key "lisp")
              "l s" '(eval-last-sexp :which-key "eval last sexp")
              "l e" '(eval-expression :which-key "eval expression")
              "l d" '(eval-defun :which-key "eval defun")

              "s" '(:ignore t :which-key "search")
              "s f" '(helm-do-ag :which-key "search in files")
              "s p" '(helm-do-ag-project-root :which-key "search in this project")
              "s b" '(helm-do-ag-buffers :which-key "search in buffers")
              "s s" '(helm-swoop :which-key "swoop")
              "s m" '(helm-multi-swoop-projectile :which-key "multi swoop")
              "s a" '(mine-do-ag-in-project :which-key "search in a project")

              "t" '(:ignore t :which-key "toggles/themes")
              "t t" '(helm-themes :which-key "select theme")
              "t n" '(global-linum-mode :which-key "toggle line numbers")
              "t r" '(treemacs :which-key "treemacs")

              "r" '(:ignore t :which-key "roam prefix")
              "r c" '(org-roam-capture :which-key "roam capture")
              "r i" '(org-roam-insert :which-key "insert link")
              "r f" '(org-roam-find-file :which-key "find note")
              "r t" '(org-roam-dailies-find-today :which-key "today")

              "i" '(:ignore t :which-key "inflection")
              "i k" '(string-inflection-kebab-case :which-key "kebab-case")
              "i j" '(string-inflection-camelcase :which-key "CamelCase")
              "i c" '(string-inflection-lower-camelcase :which-key "camelCase")

              "w" '(:ignore t :which-key "window")
              "w q" '(evil-quit :which-key "quit")
              "w s" '(evil-window-split :which-key "split window")
              "w v" '(evil-window-vsplit :which-key "vsplit window")
              "w h" '(evil-window-left :which-key "window left")
              "w H" '(evil-window-move-far-left :which-key "move window left")
              "w l" '(evil-window-right :which-key "move right")
              "w L" '(evil-window-move-far-right :which-key "move window right")
              "w k" '(evil-window-up :which-key "window up")
              "w K" '(evil-window-move-very-top :which-key "move window up")
              "w j" '(evil-window-down :which-key "window down")
              "w J" '(evil-window-move-very-bottom :which-key "move window down")

              "c" '(:ignore t :which-key "comment/code/capture")
              "c c" '(org-capture :which-key "org-capture")
              "c l" '(comment-line :which-key "toggle line comment")
              "c u" '(uncomment-region :which-key "uncomment region")
              "c r" '(comment-region :which-key "comment region")
              "c a" '(helm-lsp-code-actions :which-key "LSP - code actions"))

            (general-imap "j"
              (general-key-dispatch 'self-insert-command
                "k" 'evil-normal-state)
              "C-w" 'backward-kill-word)
          '';
        };


        dired = {
          enable = true;
          config = ''
            (define-key dired-mode-map (kbd "SPC") nil)
            (setq dired-omit-mode 1)
          '';
        };

        all-the-icons-dired = {
          enable = true;
          after = [ "all-the-icons" ];
          hook = [
            "(dired-mode . all-the-icons-dired-mode)"
          ];
        };

        polymode = {
          enable = true;
          config = '';;
            (define-hostmode poly-nix-hostmode
              :mode 'nix-mode)

            (define-innermode poly-nix-elisp-innermode
              :mode 'emacs-lisp-mode
              :head-matcher "\'\';;"
              :tail-matcher "\'\';"
              :head-mode 'host
              :tail-mode 'host)
            
            (define-polymode poly-nix-mode
              :hostmode 'poly-nix-hostmode
              :innermodes '(poly-nix-elisp-innermode))
                  
          '';
          hook = [
            "(nix-mode . poly-nix-mode)"
          ];
        };

        magit = {
          enable = true;
          command = [ "magit-status" "projectile-vc" ];
        };

        ag = {
          enable = true;
          command = [ "ag" "ag-regexp" "ag-project" ];
        };

        scala-mode = {
          enable = true;
        };

        sbt-mode = {
          enable = true;
          command = [ "sb-start" "sbt-command" ];
          config = ''
            (substitute-key-definition
              'minibuffer-complete-word
              'self-insert-command
              minibuffer-local-completion-map)
            (setq sbt:program-options '("-Dsbt.supershell=false"))
          '';
        };

        sly = {
          enable = true;
        };

        evil-collection = {
          enable = true;
          config = ''
            (evil-collection-init 'term)
            (evil-collection-init 'dired)
          '';
        };

        projectile = {
          enable = true;
          config = ''
            (projectile-global-mode)
            (setq projectile-enable-caching 1)
          '';
        };

        helm = {
          enable = true;
          config = '';;
            (setq helm-display-header-line nil
                  helm-mode-fuzzy-match t
                  helm-completion-in-region-fuzzy-match t
                  helm-buffers-fuzzy-matching t
                  helm-recentf-fuzzy-match t)
            (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
            (define-key helm-map (kbd "C-z") 'helm-select-action)
            (helm-mode 1)
          '';
        };

        helm-swoop = {
          enable = true;
        };

        helm-projectile = {
          enable = true;
          config = ''(helm-projectile-on)'';
        };

        helm-ag = {
          enable = true;
          command = [ "helm-ag" "helm-projectile-ag" ];
          config = ''
          '';
        };

        helm-icons = {
          enable = true;
          config = ''
            (helm-icons-enable)
          '';
        };

        helm-lsp = {
          enable = true;
        };

        org = {
          enable = true;
          config = '';;
            (require 'org-tempo)
            (require 'org-mouse)
            (org-babel-do-load-languages
             'org-babel-load-languages
              '((python . t)
               (shell . t)
               (ammonite . t)
               (lisp . t)))
            (setq org-babel-python-command "python3")
            (setq org-confirm-babel-evaluate nil)
            (defun my-agenda-files ()
              (seq-filter (lambda (a) (f-ext? a "org")) (f-files "~/Dropbox/org/agenda"))) 
            (setq org-agenda-files (my-agenda-files))
            (setq org-outline-path-complete-in-steps nil)
            (setq org-refile-use-outline-path t)
            (setq org-refile-targets '((nil :maxlevel . 9)
                                       (org-agenda-files :maxlevel . 9)))
            (setq org-capture-templates 
              '(("t" "Todo" entry (file "~/Dropbox/org/agenda/inbox.org") 
                "* TODO %?\n%U" :empty-lines 1)
                ("n" "Note" entry (file "~/Dropbox/org/agenda/inbox.org") 
                "* %?\n%U" :empty-lines 1)))
            (setq org-todo-keywords
              '((sequence "TODO" "NEXT" "DEFERRED" "|" "DONE")))
            (custom-set-faces
              '(org-level-1 ((t (:inherit outline-1 :height 1.1))))
              '(org-level-2 ((t (:inherit outline-2 :height 1.1))))
              '(org-level-3 ((t (:inherit outline-3 :height 1.1))))
              '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
              '(org-level-5 ((t (:inherit outline-5 :height 1.1)))))
          '';
        };

        org-roam = {
          enable = true;
          init = ''
            (setq org-roam-directory "~/Dropbox/org/roam")
          '';
          hook = [
            "(after-init . org-roam-mode)"
          ];
        };

        org-bullets = {
          enable = true;
          hook = [
            "(org-mode . org-bullets-mode)"
          ];
        };

        org-download = {
          enable = true;
        };

        mixed-pitch = {
          enable = true;
          hook = [
            "(org-mode . mixed-pitch-mode)"
          ];
        };

        dashboard = {
          enable = true;
          config = '';;
            (dashboard-setup-startup-hook)
            (setq dashboard-startup-banner 'logo)
            (setq dashboard-projects-backend 'projectile)
            (setq dashboard-set-file-icons t)
            (setq dashboard-set-heading-icons t)
            (setq dashboard-set-footer nil)
            (setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)
                        (agenda . 5)))
          '';
        };

        writeroom-mode = {
          enable = true;
        };

        ob-ammonite = {
          enable = true;
        };

        ob-http = {
          enable = true;
        };

        evil-surround = {
          enable = true;
          config = ''
            (global-evil-surround-mode)
          '';
          general = ''
            (general-vmap "s" 'evil-surround-region)
          '';
        };

        evil-matchit = {
          enable = true;
          config = ''(global-evil-matchit-mode 1)'';
        };

        evil-avy = {
          enable = true;
          config = ''
            (evil-avy-mode)
            (setq avy-case-fold-search nil)
          '';
        };

        evil-multiedit = {
          enable = true;
          config = ''
            (evil-multiedit-default-keybinds)
          '';
        };

        evil-magit = {
          enable = true;
          after = [ "evil" "magit" ];
        };

        evil-org = {
          enable= true;
          hook = [
            "(org-mode . evil-org-mode)"
          ];
          config = '';;
            (require 'evil-org-agenda)
            (evil-org-agenda-set-keys)

          '';
        };

        expand-region = {
          enable = true;
          general = ''
            (general-nvmap 
              "C-=" 'er/expand-region
              "M-C-=" 'er/contract-region)
          '';
        };

        edit-indirect = {
          enable = true;
        };

        vue-mode = {
          enable = true;
          config = ''
            (set-face-background 'mmm-default-submode-face nil)
          '';
        };

        helm-themes = {
          enable = true;
        };

        doom-themes = {
          enable = true;
          config = ''
            (load-theme 'doom-flatwhite t) 
            (doom-themes-org-config)
          '';
        };

        all-the-icons = {
          enable = true;
        };

        hasklig-mode = {
          enable = true;
          hook = [
            "(haskell-mode . hasklig-mode)"
            "(elm-mode . hasklig-mode)"
            "(scala-mode . hasklig-mode)"
          ];
        };

        doom-modeline = {
          enable = true;
          init = ''
            (doom-modeline-mode 1)
          '';
        };

        yasnippet = {
          enable = true;
          config = ''
            (yas-global-mode 1)
          '';
          general = ''
            (general-imap "C-\\" 'yas-expand)
          '';
        };

        direnv = {
          enable = true;
          config = ''
            (direnv-mode)
          '';
        };

        company = {
          enable = true;
          config = ''
            (global-company-mode)
          '';
        };

        flycheck = {
          enable = true;
          config = ''
            (global-flycheck-mode)
          '';
        };

        lsp-mode = {
          enable = true;
          hook = [
            "(scala-mode . lsp)"
            "(elm-mode . lsp)"
            "(lsp-mode . lsp-lens-mode)"
          ];
          config = ''
            (setq lsp-prefer-flymake nil)
          '';
        };

        lsp-metals = {
          enable = true;
          config = ''
            (setq lsp-metals-treeview-show-when-views-received t)
          '';
        };

        lsp-ui = {
          enable = true;
        };

        company-lsp = {
          enable = true;
        };

        treemacs = {
          enable = true;
        };

        lsp-treemacs = {
          enable = true;
        };

        treemacs-evil = {
          enable = true;
        };

        treemacs-projectile = {
          enable = true;
        };

        posframe = {
          enable = true;
        };

        dap-mode = {
          enable = true;
          hook = [
            "(lsp-mode . dap-mode)"
            "(lsp-mode . dap-ui-mode)"
          ];
        };

        dumb-jump = {
          enable = true;
          config = ''
            (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
          '';
        };

        nix = {
          enable = true;
        };

        yasnippet-snippets = {
          enable = true;
          after = [ "yasnippet" ];
        };

        smartparens = {
          enable = true;
          config = ''
            (smartparens-global-mode t)
            (require 'smartparens-config)
          '';
          hook = [
            "(lisp-mode . smartparens-strict-mode)"
            "(emacs-lisp-mode . smartparens-strict-mode)"
          ];
        };

        evil-cleverparens = {
          enable = true;
          init = '';;
            (setq evil-cleverparens-use-s-and-S nil)
          '';
          hook = [
            "(lisp-mode . evil-cleverparens-mode)"
            "(emacs-lisp-mode . evil-cleverparens-mode)"
          ];
        };


        nix-mode = {
          enable = true;
          mode = [ ''"\\.nix\\'"'' ];
        };

        elm-mode = {
          enable = true;
        };

        iedit = {
          enable = true;
        };

        string-inflection = {
          enable = true;
        };

        vterm = {
          enable = true;
          config = '';;
            (setq vterm-shell "/home/chris/.nix-profile/bin/zsh")
          '';
        };
      };
    };
  };
}

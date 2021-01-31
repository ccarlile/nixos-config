{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    
    init = {
      enable = true;
      recommendedGcSettings = true;

      prelude = ''
      ;; Disable some GUI distractions. We set these manually to avoid starting
      ;; the corresponding minor modes.
      (push '(menu-bar-lines . 0) default-frame-alist)
      (push '(tool-bar-lines . nil) default-frame-alist)
      (push '(vertical-scroll-bars . nil) default-frame-alist)
      ;; Set up fonts early.
      (set-face-attribute 'default
      nil
      :font "Hasklig-12")

        ;; Cargo-culted from rycee, I don't have a pref for this face 
        ;; but am keeping it for reference
        ;;(set-face-attribute 'variable-pitch
        ;;                    nil
        ;;                    :family "DejaVu Sans")

        (setq initial-major-mode 'org-mode)
        (setq global-auto-revert-mode 1)
        (setq backup-by-copying t)
        (setq backup-directory-alist '(("." . "~/.saves/")))
        (setq delete-old-versions t)
        (setq kept-new-versions 6)
        (setq kept-old-versions 2)
        (setq version-control t)
        (setq column-number-mode 1)
        (setq global-visual-line-mode 1)
        (setq-default indent-tabs-mode nil)
        (add-hook 'dired-mode-hook 'auto-revert-mode)
        (setq explicit-shell-file-name 
          (concat (getenv "HOME") "/.nix-profile/bin/zsh"))
      '';

      usePackage = {
        evil = {
          enable = true;
          init = ''
            (setq evil-search-module 'evil-search)
            (setq evil-ex-complete-emacs-commands nil)
            (setq evil-vsplit-window-right t)
            (setq evil-split-window-below t)
            (setq evil-shift-round nil)
            (setq evil-want-C-u-scroll t)
            (setq evil-want-Y-yank-to-eol t)
            (setq evil-want-integration nil)
            (setq evil-want-keybinding' nil)
            '';
          config = ''
            (define-key evil-normal-state-map [backspace] 
              'evil-switch-to-windows-last-buffer)
            (evil-mode)
            '';
          };

        dired = {
          enable = true;
          config = ''
            (define-key dired-mode-map (kbd "SPC") nil)
          '';
        };

        all-the-icons-dired = {
          enable = true;
          after = [ "all-the-icons" ];
          hook = [
            "(dired-mode . all-the-icons-dired-mode)"
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
            (setq projectile-enable-caching t)
          '';
        };

        helm = {
          enable = true;
          config = ''
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
        };

        org = {
          enable = true;
          config = ''
            (require 'org-tempo)
            (org-babel-do-load-languages
             'org-babel-load-languages
              '((python . t)
               (shell . t)
               (ammonite . t)
               (lisp . t)))
          '';
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
          config = ''
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

        which-key = {
          enable = true;
          config = ''
            (which-key-mode)
            (which-key-setup-minibuffer)
            (setq which-key-sort-order 'which-key-key-order-alpha
                  which-key-idle-delay 0.01)   
          '';
        };

        helm-themes = {
          enable = true;
        };

        doom-themes = {
          enable = true;
          config = ''
            (load-theme 'doom-solarized-light t) 
            (doom-themes-org-config)
          '';
        };

        all-the-icons = {
          enable = true;
        };

        telephone-line = {
          enable = true;
          config = ''
            (setq telephone-line-lhs
                  '((evil   . (telephone-line-evil-tag-segment))
                    (accent . (telephone-line-vc-segment
                               telephone-line-erc-modified-channels-segment
                               telephone-line-process-segment))
                    (nil    . (telephone-line-buffer-segment))))
            (setq telephone-line-rhs
                  '((nil    . (telephone-line-misc-info-segment))
                    (accent . (telephone-line-major-mode-segment))
                    (evil   . (telephone-line-airline-position-segment))))
            (telephone-line-mode t)
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

        posframe = {
          enable = true;
        };

        helm-posframe = {
          enable = true;
          config = ''
            (helm-posframe-enable)
          '';
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
          ];
        };

        evil-cleverparens = {
          enable = true;
          hook = [
            "(lisp-mode . evil-cleverparens-mode)"
          ];
        };

        general = {
          enable = true;
          after = [ "evil" "which-key" ];
          config = ''
            (general-evil-setup)
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

            (general-nvmap
              :keymaps 'override
              :prefix "SPC"

              "SPC" '(helm-M-x :which-key "M-x")
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

              "p" '(:ignore t :which-key "project")
              "p f" '(helm-projectile-find-file :which-key "find file")
              "p p" '(helm-projectile-switch-project :which-key "switch to project")
              "p i" '(projectile-invalidate-cache :which-key "invalidate project cache")
              "l" '(:ignore t :which-key "lisp")
              "l s" '(eval-last-sexp :which-key "eval last sexp")
              "l e" '(eval-expression :which-key "eval expression")
              "l d" '(eval-defun :which-key "eval defun")

              "s" '(:ignore t :which-key "search")
              "s f" '(helm-do-ag :which-key "search in files")
              "s p" '(helm-do-ag-project-root :which-key "search in project")
              "s b" '(helm-do-ag-buffers :which-key "search in buffers")
              "s s" '(helm-swoop :which-key "swoop")
              "s m" '(helm-multi-swoop-projectile :which-key "multi swoop")

              "t" '(:ignore t :which-key "toggles/themes")
              "t t" '(helm-themes :which-key "select theme")
              "t n" '(global-linum-mode :which-key "toggle line numbers")
              "t r" '(treemacs :which-key "treemacs")

              "i" '(:ignore t :which-key "inflection")
              "i k" '(string-inflection-kebab-case :which-key "kebab-case")
              "i j" '(string-inflection-camelcase :which-key "CamelCase")
              "i c" '(string-inflection-lower-camelcase :which-key "lowerCamelCase")
              "i p" '(string-inflection-lower-camelcase :which-key "under_score")
              
              "c" '(:ignore t :which-key "comment")
              "c l" '(comment-region :which-key "comment region")
              "c u" '(uncomment-region :which-key "uncomment region"))

            (general-imap "j"
              (general-key-dispatch 'self-insert-command
                "k" 'evil-normal-state)
              "C-w" 'backward-kill-word)
          '';
        };

        nix-mode = {
          enable = true;
          mode = [ ''"\\.nix\\'"'' ];
        };

        iedit = {
          enable = true;
        };

        string-inflection = {
          enable = true;
        };
      };
    };
  };
}

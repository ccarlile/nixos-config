{ config, pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    
    init = {
      enable = true;
      recommendedGcSettings = true;

      earlyInit = ''
      ;; Disable some GUI distractions. We set these manually to avoid starting
      ;; the corresponding minor modes.
      (push '(menu-bar-lines . 0) default-frame-alist)
      (push '(tool-bar-lines . nil) default-frame-alist)
      (push '(vertical-scroll-bars . nil) default-frame-alist)
      ;; Set up fonts early.
      (set-face-attribute 'default
      nil
      :font "Hasklig-14")

        ;; Cargo-culted from rycee, I don't have a pref for this face 
        ;; but am keeping it for reference
        ;;(set-face-attribute 'variable-pitch
        ;;                    nil
        ;;                    :family "DejaVu Sans")
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
              '';
            };
          };
        };
      };
}

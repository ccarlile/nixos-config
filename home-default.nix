{ config, pkgs, ... }:

let
  user = import ./user.nix;
in
{
  imports = [
    ./emacs-init.nix
    ./emacs.nix
  ];

  programs.git = {
    enable = true;
    userName = user.name;
    userEmail = user.email;
    ignores = [
      "*~"
      "\\#*\\#"
      "/.emacs.desktop"
      "/.emacs.desktop.lock"
      ".\#*"
      ".projectile"
      ".dir-locals.el"
      ".direnv/"
      ".envrc"
    ];
  };

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ 
      airline
      surround
      repeat
      nord-vim
    ];
    settings = {
      ignorecase = true;
      smartcase = true;
      backupdir = [ "~/.vim/backup//" ];
      directory = [ "~/.vim/backup//" ];
      number = true;
      relativenumber = true;
      expandtab = true;
    };
    extraConfig = ''
      set autoread
      set encoding=utf8
      set backspace=2
      set clipboard=unnamed
      set laststatus=2
      set noshowmode
      imap jk <esc>
      let mapleader = "\<Space>"
      nnoremap ; :
      nnoremap : ;
      nnoremap <Leader>n :bnext<CR>
      nnoremap <Leader>p :bprevious<CR>
      nnoremap <Leader>x :bdelete<CR>
      set t_Co=256
      colorscheme nord
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "refined";
      plugins = [ "fzf" ];
    };
    initExtra = ''
      export PATH="$HOME/bin:$PATH"
      fortune | cowsay

      vterm_printf(){
              printf "\e]%s\e\\" "$1"
      }
      vterm_prompt_end() {
          vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
      }
      setopt PROMPT_SUBST
      PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'
      '';
  };

  programs.fzf = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user.username;
  home.homeDirectory = user.homeDir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}

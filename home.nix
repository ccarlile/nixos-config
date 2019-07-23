{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Chris Carlile";
    userEmail = "christopher.carlile@gmail.com";
    ignores = [ "*.swp" ];
  };

  programs.vim = {
    enable = true;
    plugins = [ "vim-airline" "vim-surround" "vim-repeat" "wal-vim" ];
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
      set clipboard^=unnamed
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
      colorscheme wal
    '';
  };

  nixpkgs.config.allowUnfree = true;

  xsession.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 128;
  };
}

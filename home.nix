{ config, pkgs, ... }:

let
  fonts = import ./fonts.nix;
  dev-packages = import ./dev-packages.nix;
in
{
  imports = [
    ./home-default.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = fonts pkgs ++ dev-packages pkgs;

}

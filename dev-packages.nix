{ pkgs, ... }:

with pkgs;

[
  silver-searcher
  metals
  cowsay
  fortune
  ammonite
  elmPackages.elm-language-server
  gotop
  sqlite
  libvterm
  tree
  kakoune
]

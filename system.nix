{ config, pkgs, lib, python37, ... }:

let
  me = "chris";

  homeLocation = builtins.toPath "/home/${me}";

  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;

in
{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/7ca34be3-9b01-48a7-aaba-90f1599e2d88";
      preLVM = true;
      allowDiscards = true;
    }
  ];
 
  environment.systemPackages = 
    [ # pkgs.vim 
      pkgs.emacs 
      pkgs.git 
      pkgs.chromium 
      pkgs.gnome3.dconf-editor
      pkgs.rofi
      pkgs.zsh
      pkgs.cowsay
      pkgs.fortune
      pkgs.wpgtk
      pkgs.kitty
      pkgs.networkmanagerapplet
      pkgs.firefox
      pkgs.compton
      pkgs.wpgtk
      pkgs.pcmanfm
      pkgs.brightnessctl
      pkgs.xclip
      pkgs.dropbox
      # c compiler used for emacs sqlite
      pkgs.gcc
      pkgs.usbutils
      pkgs.zathura
      pkgs.sbcl
      pkgs.pa_applet
      pkgs.nix-prefetch-git
      # xkeysnail
    ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "megatron"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.hosts = {
    "159.89.35.54" = [ "websites" ];
  };

  users.users.chris = {
    isNormalUser = true;
    home = homeLocation;
    description = "Chris Carlile";
    extraGroups = [ "wheel" "networkmanager" "video"];
    shell = pkgs.zsh;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.compton.enable = true;
  services.compton.fade = false;
  services.compton.shadow = true;
  services.compton.backend = "glx";
  services.compton.vSync = "opengl-swc";

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.brightnessctl.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:ctrl_modifier";
  services.xserver.monitorSection = ''
    DisplaySize 508 285
  '';

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.disableWhileTyping = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      defaultFonts = {
        monospace = [ "hasklig" ];
      };
    };
    fonts = with pkgs; [
      corefonts
      hasklig
      inconsolata
      source-code-pro
      symbola
      ubuntu_font_family
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}

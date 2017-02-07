{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Boot Loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries = ''
    menuentry "Windows 10" {
      chainloader (hd0,1)+1
    }
  '';

  # Power Management
  powerManagement.enable= true;

  # Networking
  networking = {
    hostName = "skofnung";
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
    ];
  };

  # External Drives
  services.udisks2.enable = true;

  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Time zone.
  time.timeZone = "America/Los_Angeles";

  # Users
  users.extraUsers.jhope = {
    isNormalUser = true;
    home = "/home/jhope";
    description = "Jonathan Hope";
    extraGroups = ["wheel" "networkmanager"];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # Shell
  programs.zsh.enable = true;

  # Packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # Core
    gnupg
    openssl
    wget
    unzip
    p7zip
    acpi
    autorandr

    # Graphical
    rofi
    emacs
    firefox
    feh
    compton
    termite
    gtk-engine-murrine
    arc-gtk-theme
    arc-icon-theme
    gnome3.gnome_themes_standard
    lxappearance
    tint2
    python27Packages.udiskie
    xfce.thunar
    networkmanagerapplet
    pnmixer
    dropbox
    keepass
    spotify
    xtitle
    xdo

    # Dev
    git
    ack
    ag
    jdk
    python
    perl
    nodejs
    clang
    gnumake
    cmake
    pkgconfig
  ];

  # ACPI Configuration
  services.acpid = {
    enable = true;
  };

  # XServer Configuration
  services.xserver = {
    enable = true;
    # vaapiDrivers = [ pkgs.vaapiIntel pkgs.vaapiVdpau ];
    # videoDrivers = ["intel"];
    synaptics = {
      enable = true;
      twoFingerScroll = true;
    };
    layout = "us";
    displayManager.slim.defaultUser = "jhope";
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    windowManager.bspwm.enable = true;
  };

  # Make GTK themes usable.
  environment.extraInit = ''
    export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"
    export GTK_DATA_PREFIX=${config.system.path}
    export PATH=$PATH:/home/jhope/dotfiles/scripts/
  '';

  # NixOS version
  system.stateVersion = "16.09";

}

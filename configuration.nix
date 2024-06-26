# Edit this configuration file to define what should be installed on your system. Help is available in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;



  networking.hostName = "vespertine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #jack.enable = true;

    #media-session.enable = true; # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config yet)
  };

  # services.xserver.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).

  users.users.ak = { # Define a user account. Don't forget to set a password with ‘passwd’.
    isNormalUser = true;
    description = "ak";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      
      #browsers
      firefox
      brave

      #coding
      github-desktop
      vscode
      vscode-extensions.ms-python.python
      vscode-extensions.golang.go
      vscode-extensions.bbenoist.nix
      vscode-extensions.mechatroner.rainbow-csv
      vscode-extensions.davidanson.vscode-markdownlint

      #cli-tools
      kitty
      kitty-themes
      fastfetch

      #other
      gimp
      onlyoffice-bin_7_5
      remmina
      ventoy-full
      etcher
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
  #cli-tools
  vim
  wget
  nvtop
  btop

  #coding
  git
  python3
  poetry
  go

  #desktop packages
  gtk4
  gnome.gnome-tweaks
  gnome.gnome-themes-extra
  whitesur-gtk-theme
  whitesur-icon-theme
  gnomeExtensions.gtk-title-bar
  (catppuccin-gtk.override {
    accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes
    size = "compact";
    tweaks = [ "rimless" "black" ]; # You can also specify multiple tweaks here
    variant = "mocha";
  })

  ];

  # programs.mtr.enable = true; # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true; # Enable the OpenSSH daemon.

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ]; # Open ports in the firewall.
 
  # networking.firewall.enable = false; # Or disable the firewall altogether.

  system.stateVersion = "23.11"; # Before changing this value read the documentation for this option (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).


  # testing
  qt.enable = true;
  qt.platformTheme = "gtk2";
  qt.style = "gtk2";

  # Nvidia Config

  hardware.nvidia.forceFullCompositionPipeline = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = lib.mkForce ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
}

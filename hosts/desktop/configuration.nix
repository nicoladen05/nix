{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  userName = "nico";
  hostName = "desktop";
in

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # Home Manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs userName;
    };
    users = {
      "${userName}" = import ./home.nix;
    };
  };

  # Impermanence
  programs.fuse.userAllowOther = true;
  environment.persistence."/persistent" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/bluetooth"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  # System configuration
  system = {
    # Essentials
    enable = true;
    nvidia.enable = true;
    sops.enable = true;

    # User account
    inherit userName;
    inherit hostName;
    password = {
      enable = true;
      hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
    };
    passwordlessRebuild = true;

    shell = pkgs.zsh;

    # Extra settings
    bluetooth.enable = true;

    openvpn = {
      enable = true;
      persistence.enable = true;
    };

    # Firewall
    tcpPorts = [ 22 ];
    udpPorts = [ ];
  };

  # Enable I2C userspace access for ddcutil
  hardware.i2c.enable = true;

  # Package sets
  packages = {
    enable = true;
    terminal.enable = true;
    coding.enable = true;
    desktop.enable = true;
    gaming.enable = true;
    productivity.enable = true;
  };

  # Graphical configuration
  desktop = {
    audio.enable = true;
    niri.enable = true;

    # Colors
    stylix = {
      enable = true;
      colorScheme = "penumbra-dark-contrast-plus-plus";
      wallpaper = "https://raw.githubusercontent.com/tecdrop/pitch-black-wallpaper-images/f3b0910b687bf01d6cd6c5f965b398508db05c04/pitch-black-wallpaper-4k-3840x2160-1bit.png";
      wallpaperHash = "sha256-9YsrBJnOih5/3vbVQsqV/ACkyFVF5guY90T+7mlt2gw=";
    };
  };

  # Users
  users.users.nico.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.nico.hashedPasswordFile = lib.mkForce null;
  users.users.nico.extraGroups = [ "i2c" ];
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  # Gaming
  gaming = {
    enable = true;
    jovian.enable = true;
    controller.xbox.enable = true;

    assetto-corsa.enable = true;
  };

  nvf.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

    services.vaultwarden = { 
      enable = true; 
      }; 

  system.stateVersion = "24.05";
}

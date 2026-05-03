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
    useGlobalPkgs = true;
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
    cachy.enable = true;
    sops.enable = true;
    impermanence.enable = true;

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

  programs = {
    uxplay.enable = true;
    docker.enable = true;
  };

  # Graphical configuration
  desktop = {
    audio.enable = true;
    niri.enable = true;

    # Colors
    stylix = {
      enable = true;
      colorScheme = "penumbra-dark-contrast-plus-plus";
      wallpaper = "https://images.unsplash.com/photo-1776704982801-96b5ffe18928?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&dl=mak-zqqOUwE75-s-unsplash.jpg";
      wallpaperHash = "sha256-PNFEj2+XWh22/7vGZxrlkMyNEUflyd8eXUDOArL5xq8=";
    };
  };

  # Users
  users.users.nico.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.nico.hashedPasswordFile = lib.mkForce null;
  users.users.nico.extraGroups = [ "i2c" ];
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.timeout = 0;

  # Gaming
  gaming = {
    enable = true;
    controller.xbox.enable = true;
    jovian.enable = true;

    assetto-corsa.enable = true;
  };

  nvf.enable = true;

  nix.settings.trusted-users = [ "@wheel" ];

  system.stateVersion = "24.05";
}

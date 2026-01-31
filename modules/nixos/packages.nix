{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options = {
    packages.enable = lib.mkEnableOption "enable basic packages";

    packages.terminal.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.coding.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.gaming.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.productivity.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };

    packages.kde.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.packages.enable {
    # Essentials
    environment.systemPackages =
      with pkgs;
      [
        git
        killall
        wget
        gcc
        htop
        deploy-rs
      ]
      ++ lib.optionals config.packages.terminal.enable [
        neovim
        sops
      ]
      ++ lib.optionals config.packages.gaming.enable [
        mangohud

        (prismlauncher.override {
          jdks = [
            zulu
          ];
        })
      ];

    users.users."${config.system.userName}" = {
      packages =
        with pkgs;
        [
          git-crypt
          fontconfig
        ]
        ++ lib.optionals config.packages.desktop.enable [
          nur.repos.Ev357.helium
           
          pcmanfm
          discord
          spotify
          spotify-player

          poppler
          ueberzugpp

          pavucontrol
          pamixer

          sxiv
          mpv
        ]
        ++ lib.optionals config.packages.coding.enable [
          python3
          typst
          opencode
        ]
        ++ lib.optionals config.packages.productivity.enable [
          obsidian
          anki
        ]
        ++ lib.optionals config.packages.kde.enable [
          kdePackages.kcalc # Calculator
          kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
          kdePackages.kcolorchooser # A small utility to select a color
          kdePackages.kolourpaint # Easy-to-use paint program
          kdePackages.ksystemlog # KDE SystemLog Application
          kdePackages.sddm-kcm # Configuration module for SDDM
          kdiff3 # Compares and merges 2 or 3 files or directories
          kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
          kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
          hardinfo2 # System information and benchmarks for Linux systems
          haruna # Open source video player built with Qt/QML and libmpv
          wayland-utils # Wayland utilities
          wl-clipboard # Command-line copy/paste utilities for Wayland
        ];
    };

    nixpkgs.config.permittedInsecurePackages = lib.optionals config.packages.productivity.enable [
      "electron-25.9.0"
    ];

    programs.zsh.enable = lib.mkIf config.packages.terminal.enable true;
  };
}

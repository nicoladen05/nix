{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    ./impermanence.nix
    ./nh.nix
    ./nix.nix
    ./nvidia.nix
    ./openvpn.nix
    ./sops.nix
  ];

  options = {
    system = {
      enable = lib.mkEnableOption "enable the basic system configuration";

      userName = lib.mkOption {
        type = lib.types.str;
        default = "nico";
      };

      password = {
        enable = lib.mkEnableOption "enable password management";
        hashedPasswordFile = lib.mkOption {
          type = lib.types.path;
        };
      };

      passwordlessRebuild = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Rebuild the system without sudo password";
      };

      hostName = lib.mkOption {
        type = lib.types.str;
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Europe/Berlin";
        example = "Europe/Berlin";
      };

      locale.language = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        example = "en_US.UTF-8";
      };

      locale.unitFormat = lib.mkOption {
        type = lib.types.str;
        default = "de_DE.UTF-8";
        example = "de_DE.UTF-8";
      };

      shell = lib.mkOption {
        type = lib.types.package;
        default = pkgs.bash;
        example = pkgs.zsh;
      };

      boot.systemdBoot = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
      };

      bluetooth.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
      };

      tcpPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ ];
        example = [ 22 ];
      };

      udpPorts = lib.mkOption {
        type = lib.types.listOf lib.types.int;
        default = [ ];
        example = [ 22 ];
      };

      ssh = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
        allowEmptyPasswords = lib.mkOption {
          type = lib.types.bool;
          default = false;
        };
      };
    };
  };

  config = lib.mkIf config.system.enable {
    nh.enable = true;

    # Overlays
    nixpkgs.overlays = [
      (import ../../../overlays/default.nix)
      inputs.nur.overlays.default
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = lib.mkIf config.system.boot.systemdBoot true;
    boot.loader.efi.canTouchEfiVariables = lib.mkIf config.system.boot.systemdBoot true;

    # Networking
    networking.hostName = "${config.system.hostName}";
    networking.networkmanager.enable = true;

    # Timezone
    time.timeZone = "${config.system.timeZone}";

    # Locale
    i18n.defaultLocale = "${config.system.locale.language}";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "${config.system.locale.unitFormat}";
      LC_IDENTIFICATION = "${config.system.locale.unitFormat}";
      LC_MEASUREMENT = "${config.system.locale.unitFormat}";
      LC_MONETARY = "${config.system.locale.unitFormat}";
      LC_NAME = "${config.system.locale.unitFormat}";
      LC_NUMERIC = "${config.system.locale.unitFormat}";
      LC_PAPER = "${config.system.locale.unitFormat}";
      LC_TELEPHONE = "${config.system.locale.unitFormat}";
      LC_TIME = "${config.system.locale.unitFormat}";
    };

    # Users
    users.users."${config.system.userName}" = {
      isNormalUser = true;
      description = "${config.system.userName}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = config.system.shell;
      hashedPasswordFile = lib.mkIf config.system.password.enable "${config.system.password.hashedPasswordFile
      }";
      openssh.authorizedKeys.keys = import ../../../configs/ssh/authorized-keys.nix;
    };

    users.users.root = {
      hashedPasswordFile = lib.mkIf config.system.password.enable "${config.system.password.hashedPasswordFile
      }";
    };

    # Rebuild without password
    security.sudo.extraRules = lib.mkIf config.system.passwordlessRebuild [
      {
        users = [ "${config.system.userName}" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/nix";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/systemctl";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-env";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-store";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    # Bluetooth
    hardware.bluetooth = lib.mkIf config.system.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        experimental = true;
        FastConnectable = true;
      };
    };
    services.blueman.enable = lib.mkIf config.system.bluetooth.enable true;

    networking.firewall.allowedTCPPorts = config.system.tcpPorts;
    networking.firewall.allowedUDPPorts = config.system.udpPorts;

    # SSH
    services.openssh = lib.mkIf config.system.ssh.enable {
      enable = true;
    };

    nixpkgs.config.allowUnfree = true;
  };
}

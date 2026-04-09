{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}:

let
  userName = "nico";
  hostName = "vps";
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/homelab
  ];

  # System config
  system = {
    enable = true;
    sops.enable = true;

    inherit userName;
    inherit hostName;

    passwordlessRebuild = true;

    shell = pkgs.zsh;

    udpPorts = [ 24454 ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [ pkgs.flite ];

  homelab = {
    enable = true;
    external = true;

    configDir = "/opt/services";
    baseDomain = "nicoladen.dev";

    services = {
      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "mc.nicoladen.dev"
          "mc2.nicoladen.dev"
          "vps.nicoladen.dev"
          "n8n.nicoladen.dev"
          "minio.nicoladen.dev"
        ];
      };

      hytale-server.enable = false;

      minecraft-server =
        let
          servers = import ../../configs/minecraft/servers.nix { inherit pkgs; };
          filteredServers = lib.filterAttrs (_: server: server.host == "vps") servers;
        in
        {
          enable = true;
          servers = lib.mapAttrs (
            name: config:
            removeAttrs config [
              "host"
              "domain"
            ]
          ) filteredServers;
        };

      n8n.enable = true;

      glance.agent = {
        enable = true;
        settings.tokenFile = config.sops.templates."glance/vps_remote_env".path;
      };

      minio.enable = true;

      pyrodactyl.enable = false;
    };
  };

  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = false;
    };
  };

  users.users.nico.extraGroups = [ "docker" ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      userName = "${config.system.userName}";
    };
    users = {
      "nico" = import ./home.nix;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    targets.nvf.enable = false;
  };

  packages = {
    enable = true;
    terminal.enable = true;
    coding.enable = true;
  };

  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.mosh = {
    enable = true;
    openFirewall = true;
  };

  services.fail2ban.enable = true;

  nix.settings.trusted-users = [ "${config.system.userName}" ];

  system.stateVersion = "25.05";

  # Static ip
  networking = {
    defaultGateway = "10.0.0.1";
    nameservers = [
      "8.8.8.8"
    ];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.68"; # This is the ip address configured in oracle cloud
          prefixLength = 24;
        }
      ];
      # For IPv6
      useDHCP = true;
    };
  };
}

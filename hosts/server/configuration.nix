{
  config,
  lib,
  pkgs,
  ...
}:

let
  userName = "nico";
  hostName = "server";
in
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../modules/homelab
  ];

  # System configuration
  system = {
    enable = true;
    sops.enable = true;

    # User account
    inherit userName;
    inherit hostName;
    password = {
      enable = true;
      hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
    };
    passwordlessRebuild = true;
    ssh.enable = true;
    tcpPorts = [ 22 ];
  };

  # Homelab
  homelab = {
    enable = true;
    external = true;

    baseDomain = "nicoladen.dev";
    internalDomain = "taube.party";

    services = {
      audiobookshelf.enable = true;

      backup = {
        enable = true;
        repositoryFile = config.sops.secrets."restic/repository".path;
        passwordFile = config.sops.secrets."restic/password".path;
      };

      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "*.nicoladen.dev"
          "ddns.nicoladen.dev"
        ];
      };

      botify = {
        enable = true;
        tokenFile = config.sops.secrets."services/botify/token".path;
        openaiTokenFile = config.sops.secrets."services/botify/openai_api_key".path;
      };

      glance.enable = true;

      immich = {
        enable = true;
        hardwareAcceleration = true;
        mediaLocation = "/data/immich";
      };

      media.enable = true;

      norish.enable = true;

      pihole.enable = true;

      paperless.enable = true;

      homeassistant = {
        enable = true;
        expose = true;
      };

      vaultwarden.enable = true;

      spoolman.enable = true;
      spoolman.filabridge.enable = true;

      shelfmark.enable = true;

      prusa-octoapp-proxy.enable = true;

      ocis.enable = true;

      wireguard = {
        enable = true;
        externalInterface = "enp1s0";
        ips = [
          "192.168.255.1/32"
          "fd3a:6c4f:1b2e::1/128"
          "2003:e0:17ff:3b42::1/128"
        ];
        privateKeyFile = config.sops.secrets."wireguard/privkey".path;
        peers = {
          # Family
          phone = {
            publicKey = "HUJGJf2uFa8p8EpwQNS5ZKz06qIQOd1uquA8zGkB1Ag=";
            allowedIPs = [
              "192.168.255.2/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          ipad = {
            publicKey = "YRgKxkrWXRrW0Bxpw+w8PCLzPp+2+Luo2TtneZIz+Sc=";
            allowedIPs = [
              "192.168.255.3/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          ipad-luca = {
            publicKey = "83uqVPr2ojPfNDFa0FWy1o6A6qgGJZmeRAR/5rPBVjs=";
            allowedIPs = [
              "192.168.255.4/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          micha = {
            publicKey = "0yiBvElispoc7aktPpL4N7YBmMa3YIPqFq+moR2FUlc=";
            allowedIPs = [
              "192.168.255.5/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          oma = {
            publicKey = "hmwzZN/BHlevUy0amqL/N9VlFP6+NynmmqBm0nziVGw=";
            allowedIPs = [
              "192.168.255.10/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };

          # Friends
          jakob = {
            publicKey = "+i9swa1iKylRcFyp8miERswwqRgMsNy1aW7nnxmg9Hc=";
            allowedIPs = [
              "192.168.255.101/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          olli = {
            publicKey = "HDmDmvKzWQtryIjjVWphF8O/xZRoj5FyGncbE5htIU0=";
            allowedIPs = [
              "192.168.255.102/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
        };
      };
    };
  };

  # Static ip
  networking = {
    nameservers = [
      "1.1.1.1"
    ];
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.2.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.2.1";
      interface = "enp1s0";
    };
  };

  services.postgresql.package = pkgs.postgresql_17;

  # Users
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}

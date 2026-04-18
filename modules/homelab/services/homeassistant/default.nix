{
  lib,
  config,
  network,
  ...
}:

let
  cfg = config.homelab.services.homeassistant;
in
{
  options = {
    homelab.services.homeassistant = {
      enable = lib.mkEnableOption "enables homeassistant";

      url = lib.mkOption {
        type = lib.types.str;
        default = "home.${config.homelab.baseDomain}";
      };

      expose = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      configDir = lib.mkOption {
        type = lib.types.path;
        default = "${config.homelab.configDir}/hass";
      };

      esphomeConfigDir = lib.mkOption {
        type = lib.types.path;
        default = "${config.homelab.configDir}/esphome";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0775 nico users -"
      "d ${cfg.esphomeConfigDir} 0775 nico users -"
    ];

    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = false;
      };
    };

    virtualisation.oci-containers.containers."homeassistant" = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      pull = "newer";
      volumes = [
        "${toString cfg.configDir}:/config"
      ];
      environment = {
        TZ = config.system.timeZone;
      };
      extraOptions = [
        "--network=host"
        "--pull=newer"
        "--dns=${network.clients.router.ip}"
      ];
    };

    virtualisation.oci-containers.containers."esphome" = {
      image = "ghcr.io/esphome/esphome:latest";
      autoStart = true;
      pull = "newer";
      privileged = true;
      volumes = [
        "${toString cfg.esphomeConfigDir}:/config"
      ];
      environment = {
        TZ = config.system.timeZone;
        ESPHOME_DASHBOARD_USE_PING = "true";
      };
      extraOptions = [
        "--network=host"
        "--pull=newer"
        "--dns=${network.clients.router.ip}"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      8123
      6052
    ];

    services.caddy.virtualHosts = {
      "${cfg.url}:444" = lib.mkIf cfg.expose {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8123
        '';
      };

      "home.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8123
        '';
      };

      "esphome.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:6052
        '';
      };
    };
  };
}

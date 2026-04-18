{ lib, config, ... }:

let
  cfg = config.homelab.services.immich;
in
{
  options.homelab.services.immich = {
    enable = lib.mkEnableOption "Enable Immich";

    url = lib.mkOption {
      type = lib.types.str;
      default = "immich.${config.homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 2283;
    };

    hardwareAcceleration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    mediaLocation = lib.mkOption {
      type = lib.types.str;
      default = "/opt/services/immich";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create mediaLocation if it does not exist and set permission
    systemd.tmpfiles.rules = [
      "d ${cfg.mediaLocation} 0755 immich immich -"
    ];

    # Immich config
    services.immich = {
      enable = true;
      accelerationDevices = lib.mkIf cfg.hardwareAcceleration [ "/dev/dri/renderD128" ];
      mediaLocation = cfg.mediaLocation;
      openFirewall = true;
      host = "0.0.0.0";
      port = cfg.port;
      settings.server.externalDomain = "https://${cfg.url}";
    };

    #networking.firewall.allowedTCPPorts = [ 2283 ];

    services.caddy.virtualHosts = {
      "${cfg.url}:444" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };

      "immich.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };
    };
  };
}

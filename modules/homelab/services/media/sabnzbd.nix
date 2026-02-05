{ lib, config, ... }:

let
  cfg = config.homelab.services.media.sabnzbd;
  media = config.homelab.services.media;
in
{
  options.homelab.services.media.sabnzbd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = media.enable;
      example = false;
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8086;
      example = 8086;
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sabnzbd";
      example = "/var/lib/sabnzbd";
      description = "Directory for SABnzbd data";
    };

    downloadsDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/media/usenet";
      example = "/var/lib/media/downloads";
      description = "Directory for downloads";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.sabnzbd = {
      image = "lscr.io/linuxserver/sabnzbd:latest";
      ports = [ "${toString cfg.port}:8080" ];
      volumes = [
        "${cfg.dataDir}:/config"
        "${cfg.downloadsDir}:/downloads"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = config.time.timeZone;
      };
      extraOptions = [ "--pull=newer" ];
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];

    services.caddy.virtualHosts = {
      "sabnzbd.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${toString cfg.port}
        '';
      };
    };
  };
}

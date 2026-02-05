{ lib, config, ... }:

let
  cfg = config.homelab.services.media.jellyfin;
  media = config.homelab.services.media;
in
{
  options.homelab.services.media.arr = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = media.enable;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = true;
      openFirewall = true;
      group = "users";
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
      group = "users";
    };

    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

    services.jellyseerr = {
      enable = true;
      openFirewall = true;
    };

    services.caddy.virtualHosts = {
      "sonarr.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8989
        '';
      };
      "radarr.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:7878
        '';
      };
      "prowlarr.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:9696
        '';
      };
      "jellyseerr.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:5055
        '';
      };
    };
  };
}

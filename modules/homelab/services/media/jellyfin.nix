{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.media.jellyfin;
  media = config.homelab.services.media;
in
{
  options.homelab.services.media.jellyfin = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = media.enable;
      example = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
      group = "users";
    };

    hardware.graphics = {
      enable = true;
      extraPackages = [ pkgs.intel-media-driver ];
    };

    services.caddy.virtualHosts = {
      "jellyfin.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8096
        '';
      };
    };
  };
}

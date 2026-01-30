{ lib, config, ... }:

let
  cfg = config.homelab.services.audiobookshelf;
in
{
  options.homelab.services.audiobookshelf = {
    enable = lib.mkEnableOption "Enable Audiobookshelf";

    port = lib.mkOption {
      type = lib.types.int;
      default = 8929;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/data/audiobooks";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0755 audiobookshelf audiobookshelf -" ];

    services.audiobookshelf = {
      enable = true;
      openFirewall = true;
      inherit (cfg) port;
    };

    services.caddy.virtualHosts = {
      "audiobookshelf.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${toString cfg.port}
        '';
      };
    };
  };
}

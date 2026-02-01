{ lib, config, ... }:

let
  cfg = config.homelab.services.paperless;
in
{
  options.homelab.services.paperless = {
    enable = lib.mkEnableOption "Enable Paperless";
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/data/paperless";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0775 paperless users -"
    ];

    services.paperless = {
      enable = true;
      address = "0.0.0.0";
      mediaDir = cfg.dataDir;
      settings = {
        PAPERLESS_CONSUMER_IGNORE_PATTERN = [
          ".DS_STORE/*"
          "desktop.ini"
        ];
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_URL = "https://paperless.${config.homelab.internalDomain}";
      };
    };

    networking.firewall.allowedTCPPorts = [ 28981 ];

    services.caddy.virtualHosts = {
      "paperless.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:28981
        '';
      };
    };
  };
}

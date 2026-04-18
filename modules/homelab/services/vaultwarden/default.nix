{ config, lib, ... }:

let
  cfg = config.homelab.services.vaultwarden;
in
{
  options = {
    homelab.services.vaultwarden = {
      enable = lib.mkEnableOption "Enable Vaultwarden";
      backupDir = lib.mkOption {
        type = lib.types.str;
        default = "/opt/services/vaultwarden";
      };
      url = lib.mkOption {
        type = lib.types.str;
        default = "vaultwarden.${config.homelab.baseDomain}";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8222;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.vaultwarden = {
      enable = true;
      backupDir = cfg.backupDir;
      config = {
        DOMAIN = "https://${cfg.url}";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "0.0.0.0";
        ROCKET_PORT = cfg.port;
        ROCKET_LOG = "critical";
      };
    };

    networking.firewall.allowedTCPPorts = [ 8222 ];

    services.caddy.virtualHosts = {
      "${cfg.url}:444" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };

      "vaultwarden.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };
    };
  };
}

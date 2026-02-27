{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.n8n;
in
{
  options.homelab.services.n8n = {
    enable = lib.mkEnableOption "Enable Cloudflare DDNS";

    url = lib.mkOption {
      type = lib.types.str;
      default = "n8n.${config.homelab.baseDomain}";
    };
  };

  config = lib.mkIf cfg.enable {
    services.n8n = {
      enable = true;
      environment = {
        WEBHOOK_URL = "https://${cfg.url}";
        N8N_RUNNERS_AUTH_TOKEN_FILE = pkgs.writeText "n8n-empty-runner-token" "";
      };
    };

    services.caddy.virtualHosts = {
      "${cfg.url}" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:5678
        '';
      };
    };
  };
}

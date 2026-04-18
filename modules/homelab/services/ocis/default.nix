{ config, lib, ... }:

let
  cfg = config.homelab.services.ocis;
in
{
  options.homelab.services.ocis = {
    enable = lib.mkEnableOption "OCIS Cloud";

    url = lib.mkOption {
      type = lib.types.str;
      default = "cloud.${config.homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 9200;
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.homelab.configDir}/ocis";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.configDir} 0770 ocis users -"
    ];

    services.ocis = {
      enable = true;
      address = "0.0.0.0";
      url = "https://${cfg.url}";

      stateDir = "/data/ocis";

      inherit (cfg) port configDir;

      environment = {
        PROXY_HTTP = "true";
        PROXY_TLS = "false";
        OCIS_INSECURE = "true";
        OCIS_LOG_COLOR = "true";

        # Disable forced password on shares
        OCIS_SHARING_PUBLIC_SHARE_MUST_HAVE_PASSWORD = "false";
        OCIS_SHARING_PUBLIC_WRITEABLE_SHARE_MUST_HAVE_PASSWORD = "false";

        PROXY_ENABLE_BASIC_AUTH = "true";
      };
    };

    networking.firewall.allowedTCPPorts = [ 9200 ];

    services.caddy.virtualHosts = {
      "${cfg.url}:444" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };

      "ocis.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };
    };
  };
}

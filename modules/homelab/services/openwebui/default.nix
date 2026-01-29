{ lib, config, ... }:

let
  cfg = config.homelab.services.openwebui;
in
{
  options.homelab.services.openwebui = {
    enable = lib.mkEnableOption "Enable OpenWebUI";

    url = lib.mkOption {
      type = lib.types.str;
      default = "chat.${config.homelab.baseDomain}";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 3000;
    };
  };

  config = lib.mkIf cfg.enable {
    services.open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = cfg.port;
      openFirewall = true;
    };

    services.caddy.virtualHosts = {
      "chat.${config.homelab.baseDomain}:444" = {
        extraConfig = ''
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };

      "chat.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };
    };
  };
}

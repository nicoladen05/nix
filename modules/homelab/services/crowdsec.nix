{
  lib,
  config,
  pkgs,
  ...
}:

let
  port = 4722;
  user = "crowdsec";
  group = "crowdsec";
in
{
  config = lib.mkIf config.homelab.external {
    systemd.tmpfiles.rules = [ "d /var/lib/crowdsec 0750 ${user} ${group} -" ];

    users.users.crowdsec.extraGroups = [ "caddy" ];

    services = {
      crowdsec = {
        enable = true;

        settings = {
          general = {
            api.server = {
              enable = true;
              listen_uri = "127.0.0.1:${toString port}";
            };
          };

          lapi.credentialsFile = "/var/lib/crowdsec/lapi.yaml";
          capi.credentialsFile = "/var/lib/crowdsec/capi.yaml";

          console = {
            tokenFile = config.sops.secrets."crowdsec/enrollment_key".path;
            configuration = {
              share_context = true;
              share_custom = true;
              share_manual_decisions = true;
              share_tainted = true;
              console_management = true;
            };
          };
        };

        localConfig = {
          acquisitions = [
            {
              journalctl_filter = [
                "_SYSTEMD_UNIT=sshd.service"
              ];
              labels.type = "syslog";
              source = "journalctl";
            }

            {
              filenames = [ "/var/log/caddy/*.log" ];
              labels.type = "caddy";
            }
          ];
        };

        hub = {
          collections = [ "crowdsecurity/linux" "crowdsecurity/caddy" ];
          scenarios = [
            "gauth-fr/immich-bf"
            "crowdsecurity/home-assistant-bf"
            "Dominic-Wagner/vaultwarden-bf"
          ];
        };
      };
    };

  };
}

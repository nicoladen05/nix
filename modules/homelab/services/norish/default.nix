{
  lib,
  config,
  network,
  ...
}:

let
  cfg = config.homelab.services.norish;
  dbName = "norish";
  dbUser = "norish";
  dbPassword = "norish";
  port = toString cfg.port;
in
{
  options.homelab.services.norish = {
    enable = lib.mkEnableOption "Enable Norish";

    url = lib.mkOption {
      type = lib.types.str;
      default = "norish.${config.homelab.baseDomain}";
    };

    internalUrl = lib.mkOption {
      type = lib.types.str;
      default = "norish.${config.homelab.internalDomain}";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/norish";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0775 nico users -"
      "d ${cfg.dataDir}/uploads 0775 nico users -"
    ];

    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = false;
    };

    services.postgresql = {
      enable = true;
      enableTCPIP = true;
      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = dbUser;
          ensureDBOwnership = true;
        }
      ];
      authentication = ''
        host ${dbName} ${dbUser} 10.88.0.0/16 scram-sha-256
      '';
    };

    systemd.services.norish-postgresql-password = {
      wantedBy = [ "multi-user.target" ];
      after = [ "postgresql-setup.service" ];
      requires = [ "postgresql-setup.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
      };
      script = ''
        ${config.services.postgresql.finalPackage}/bin/psql -tAc "ALTER USER ${dbUser} WITH PASSWORD '${dbPassword}'"
      '';
    };

    services.redis.servers.norish = {
      enable = true;
      port = 6379;
      bind = "0.0.0.0";
      settings.protected-mode = false;
    };

    virtualisation.oci-containers.containers."chrome-headless" = {
      image = "zenika/alpine-chrome:latest";
      autoStart = true;
      pull = "newer";
      cmd = [
        "--no-sandbox"
        "--disable-gpu"
        "--disable-dev-shm-usage"
        "--remote-debugging-address=0.0.0.0"
        "--remote-debugging-port=3000"
        "--headless"
      ];
      ports = [ "3010:3000" ];
      extraOptions = [
        "--pull=newer"
        "--dns=${network.clients.router.ip}"
      ];
    };

    virtualisation.oci-containers.containers."norish" = {
      image = "norishapp/norish:latest";
      autoStart = true;
      pull = "newer";
      user = "1000:1000";
      dependsOn = [ "chrome-headless" ];
      ports = [ "${port}:3000" ];
      volumes = [ "${toString cfg.dataDir}/uploads:/app/uploads" ];
      environment = {
        AUTH_URL = "https://${cfg.url}";
        DATABASE_URL = "postgres://${dbUser}:${dbPassword}@host.docker.internal:5432/${dbName}";
        MASTER_KEY = "/Y5F50GSbNY/FqWwqUJHuGZatJ+HotMqrKaSh8GhoXQ=";
        CHROME_WS_ENDPOINT = "ws://host.docker.internal:3010";
        REDIS_URL = "redis://host.docker.internal:6379";
        UPLOADS_DIR = "/app/uploads";
        AI_ENABLED = "true";
        VIDEO_PARSING_ENABLED = "true";
        TRANSCRIPTION_PROVIDER = "openai";
        TRANSCRIPTION_MODEL = "whisper-1";
        TRUSTED_ORIGINS = "https://${cfg.url},https://${cfg.internalUrl}";
      };
      environmentFiles = [ config.sops.templates."norish/env".path ];
      extraOptions = [
        "--add-host=host.docker.internal:host-gateway"
        "--pull=newer"
        "--dns=${network.clients.router.ip}"
      ];
    };

    systemd.services.podman-norish = {
      after = [
        "norish-postgresql-password.service"
        "redis-norish.service"
      ];
      requires = [
        "norish-postgresql-password.service"
        "redis-norish.service"
      ];
    };

    networking.firewall.interfaces.podman0.allowedTCPPorts = [
      5432
      6379
      3010
    ];

    services.caddy.virtualHosts = {
      "${cfg.url}:444" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${port}
        '';
      };

      "${cfg.internalUrl}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${port}
        '';
      };
    };
  };
}

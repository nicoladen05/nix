{
  lib,
  config,
  network,
  ...
}:

let
  cfg = config.homelab.services.shelfmark;
in
{
  options.homelab.services.shelfmark = {
    enable = lib.mkEnableOption "Enable Shelfmark";

    booksDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/shelfmark/books";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/shelfmark/config";
    };

    downloadsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/downloads";
      description = "Path to downloads directory for torrent/usenet support";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.booksDir} 0775 nico users -"
      "d ${cfg.configDir} 0775 nico users -"
    ]
    ++ lib.optional (cfg.downloadsDir != null) "d ${cfg.downloadsDir} 0775 nico users -";

    virtualisation.containers.enable = true;
    virtualisation.oci-containers.backend = "podman";
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = false;
      };
    };

    virtualisation.oci-containers.containers."shelfmark" = {
      image = "ghcr.io/calibrain/shelfmark:latest";
      autoStart = true;
      pull = "newer";
      ports = [
        "8084:8084"
      ];
      volumes = [
        "${toString cfg.booksDir}:/books"
        "${toString cfg.configDir}:/config"
      ]
      ++ lib.optional (
        cfg.downloadsDir != null
      ) "${toString cfg.downloadsDir}:${toString cfg.downloadsDir}";
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      extraOptions = [ "--pull=newer" ];
    };

    networking.firewall.allowedTCPPorts = [ 8084 ];

    services.caddy.virtualHosts = {
      "shelfmark.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:8084
        '';
      };
    };
  };
}

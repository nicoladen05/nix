{
  lib,
  config,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.homelab.external {
    services.caddy = {
      enable = true;
      acmeCA = "https://acme-v02.api.letsencrypt.org/directory";
      email = "acme@nicoladen.dev";

      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.2" ];
        hash = "sha256-7DGnojZvcQBZ6LEjT0e5O9gZgsvEeHlQP9aKaJIs/Zg=";
      };

      environmentFile = config.sops.templates."caddy-env".path;

      extraConfig = ''
        (cloudflare_dns) {
          tls {
            dns cloudflare {env.CLOUDFLARE_API_TOKEN}
            propagation_delay 10s
            propagation_timeout 2m
          }
        }
      '';
    };

    sops.templates."caddy-env".content = ''
      CLOUDFLARE_API_TOKEN=${config.sops.placeholder."cloudflare/api_token"}
    '';

    # Ensure crowdsec can read caddy logs
    systemd.services.caddy.serviceConfig.LogsDirectoryMode = "0750";

    networking.firewall.allowedTCPPorts = [
      80
      443
      81
      444
    ];
  };
}

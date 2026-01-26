{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.homelab.services.hytale-server;
in
{
  imports = [ inputs.hytale-server-nix.nixosModules.default ];

  options.homelab.services.hytale-server = {
    enable = lib.mkEnableOption "Hytale Server";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        hytale-server = inputs.hytale-server-nix.packages.${final.hostPlatform.system}.default;
      })
    ];

    services.hytale-server = {
      enable = true;
      assets = "/var/lib/hytale-server/assets.zip";
      openFirewall = true;
      jvmOptions = [
        "-Xmx4G"
        "-Xms4G"
      ];

      universe = "/var/lib/hytale-server/universe";

      package = pkgs.hytale-server.overrideAttrs (oldAttrs: {
        version = "2026.01.22";
        src = pkgs.requireFile {
          name = "HytaleServer.jar";
          hash = "sha256-OEftAQOkJIG+4xzs6M+A4QN6gKge4+vqxf2gKbgiwGE=";
          message = ''
            The Hytale server cannot be downloaded automatically.
            Please download it manually:

            1. Run the official Hytale launcher and extract the server, OR
            2. Use the official download script from Hytale

            After obtaining HytaleServer.jar, add it to the Nix store:
              nix-store --add-fixed sha256 HytaleServer.jar

            Or using nix-prefetch-url:
              nix-prefetch-url --type sha256 file:///path/to/HytaleServer.jar
          '';
        };
      });

      plugins = [
        (pkgs.fetchurl {
          url = "https://github.com/G-PORTAL/hytale-plugin-query/releases/download/1.2.1/gportal-query-1.2.1.jar";
          hash = "sha256-RpEK9Uj/Z34u+T2wHGEmg7gE8qn0qGrFl8+m/jRvnCk=";
        })
      ];
    };

    services.restic.backups."hytale-server" = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;
      timerConfig = {
        OnCalendar = "04:00";
      };
      paths = [ "/var/lib/hytale-server" ];
      pruneOpts = [ "--keep-daily 2" ];
    };

    # This is the port used by the query plugin
    networking.firewall.allowedUDPPorts = [ 5521 ];
  };
}

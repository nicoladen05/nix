{ ... }:

{
  imports = [
    ./caddy.nix
    ./crowdsec.nix
    ./ddns.nix

    ./audiobookshelf
    ./backup
    ./blocky
    ./botify
    ./code-server
    ./glance
    ./homeassistant
    ./hytale
    ./immich
    ./media
    ./minecraft
    ./minio
    ./n8n
    ./norish
    ./ocis
    ./openwebui
    ./paperless
    ./pihole
    ./prusa-octoapp-proxy
    ./pyrodactyl
    ./shelfmark
    ./spoolman
    ./vaultwarden
    ./windows
    ./wireguard
  ];
}

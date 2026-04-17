{ lib, config, ... }:

{
  options = {
    system.sops = {
      enable = lib.mkEnableOption "enable sops";

      secretsFile = lib.mkOption {
        type = lib.types.path;
        default = ../../../secrets/secrets.yaml;
      };

      ageKeyFile = lib.mkOption {
        type = lib.types.path;
        default = builtins.toPath "/home/${config.system.userName}/.config/sops/age/keys.txt";
      };
    };
  };

  config = lib.mkIf config.system.sops.enable {
    sops.defaultSopsFile = config.system.sops.secretsFile;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = config.system.sops.ageKeyFile;

    sops.secrets."user/nico/password" = { };
    sops.secrets."user/nico/password_long" = { };
    sops.secrets."user/nico/password_hash" = {
      neededForUsers = true;
    };

    sops.secrets."wireguard/privkey" = {
      mode = "0640";
      owner = "systemd-network";
    };

    sops.secrets."cloudflare/api_token" = { };

    sops.secrets."homeassistant/url" = { };
    sops.secrets."homeassistant/token" = { };

    sops.secrets."google/calendar/client_id" = {
      owner = config.system.userName;
    };
    sops.secrets."google/calendar/client_secret" = {
      owner = config.system.userName;
    };

    sops.secrets."restic/password" = { };
    sops.secrets."restic/repository" = { };

    sops.secrets."glance/pihole_password" = { };
    sops.secrets."glance/immich_api_key" = { };
    sops.secrets."glance/3d_printer_remote" = { };
    sops.secrets."glance/vps_remote" = { };

    sops.templates."glance/vps_remote_env".content = ''
      TOKEN=${config.sops.placeholder."glance/vps_remote"}
    '';

    sops.templates."homeassistant/ha_mcp_env" = {
      content = ''
        export HOMEASSISTANT_URL=${config.sops.placeholder."homeassistant/url"}
        export HOMEASSISTANT_TOKEN=${config.sops.placeholder."homeassistant/token"}
      '';
      owner = config.system.userName;
      mode = "0400";
    };

    sops.secrets."glance_restic/password" = { };
    sops.secrets."glance_restic/url" = { };

    sops.secrets."crowdsec/enrollment_key" = { };
  };
}

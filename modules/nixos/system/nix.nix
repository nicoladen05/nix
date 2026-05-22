{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.system.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      extraOptions = ''
        warn-dirty = false
      '';

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      optimise = {
        automatic = true;
        dates = [ "03:45" ];
      };
    };

    system.autoUpgrade = {
      enable = true;
      flake = "github:nicoladen05/nix#${config.system.hostName}";
      dates = "4:00";
      flags = [ "-L --refresh" ];
      upgrade = false;
      allowReboot = true;
    };

    # Notify on upgrade failure
    systemd.services.nixos-upgrade.onFailure = [ "nixos-upgrade-failure-notification.service" ];

    systemd.services.nixos-upgrade-failure-notification = {
      description = "Send a notification for failed NixOS upgrades";

      serviceConfig.Type = "oneshot";

      script = ''
        NTFY_URL="$(cat ${config.sops.secrets."ntfy/topic".path})"
        LOGS="$(${pkgs.systemd}/bin/journalctl -u nixos-upgrade.service -n 50 --no-pager --output=short-iso)"

        ${pkgs.curl}/bin/curl \
            -H "Title: Auto-upgrade failed: ${config.system.hostName}" \
            -H "Priority: high" \
            -d "$LOGS" \
            "$NTFY_URL"
      '';
    };
  };
}

{ lib, config, ... }:

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
  };
}

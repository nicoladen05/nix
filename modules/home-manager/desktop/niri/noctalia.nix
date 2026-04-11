{ config, lib, ... }:

{
  config = lib.mkIf config.home-manager.niri.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        colorSchemes = {
          darkMode = true;
          syncGsettings = true;
        };
        notifications.overlayLayer = true;
        osd.overlayLayer = true;
      };
    };
  };
}

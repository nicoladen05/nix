{ config, lib, ... }:

{
  config = lib.mkIf config.home-manager.niri.enable {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;
      settings = {
        close_on_focus_loss = true;
        favicon_service = "twenty";
        font.normal = {
          family = "Maple Mono NF CN";
          size = 10;
        };
      };
    };
  };
}

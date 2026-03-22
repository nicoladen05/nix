{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    desktop.niri.enable = lib.mkEnableOption "enable niri";
  };

  config = lib.mkIf config.desktop.niri.enable {
    programs.niri.enable = true;

    environment.sessionVariables = lib.mkIf config.system.nvidia.enable {
      NIXOS_OZONE_WL = "1";
    };

    # Keyring
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # XDG Portals
    xdg.portal = {
      enable = true;
      wlr.enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}

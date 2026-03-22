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
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_DXVK_USE_LAST_PIPELINE_CACHE = "1";
      __GL_GSYNC_ALLOWED = "1";
      LIBVA_DRIVER_NAME = "nvidia";

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

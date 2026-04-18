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

    # # This patches a flickering bug with niri on nvidia
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     niri = prev.niri.overrideAttrs (old: {
    #       patches = (old.patches or [ ]) ++ [
    #         ./niri-flickering-fix.patch
    #       ];
    #     });
    #   })
    # ];

    # Switch boot entry from dms bar
    environment.systemPackages = [ pkgs.efibootmgr ];
    security.sudo.extraConfig = ''
      Cmnd_Alias DMS_EFIBOOTMGR = \
        /run/current-system/sw/bin/efibootmgr --bootnext [0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f], \
        /run/current-system/sw/bin/efibootmgr --delete-bootnext

      %wheel ALL=(root) NOPASSWD: DMS_EFIBOOTMGR
    '';

    # Keyring
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # Display Manager
    services.displayManager = {
      enable = true;

      dms-greeter = {
        enable = true;
        compositor.name = "niri";
      };
    };

    # Boot Animation
    boot.plymouth = {
      enable = true;
    };

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

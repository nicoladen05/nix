{
  lib,
  pkgs,
  config,
  ...
}:

let
  menus = import ./menus.nix { inherit pkgs; };
in
{
  imports = [
    ./noctalia.nix
    ./vicinae.nix
    ./wlsunset.nix
  ];

  options = {
    home-manager.niri.enable = lib.mkEnableOption "enable niri";
  };

  config = lib.mkIf config.home-manager.niri.enable {
    home.packages = with pkgs; [
      xwayland-satellite
      wl-clipboard
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      swaybg
      playerctl
      menus.niriPowerMenu
      menus.niriActionsMenu
    ];

    home.file.".config/niri/config.kdl".source = ./config.kdl;
    home.file.".config/niri/wallpaper.jpg".source = config.stylix.image;

    # Apps in dark mode
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = lib.mkForce "prefer-dark";
        };
      };
    };
  };
}

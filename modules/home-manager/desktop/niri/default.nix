{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.config
    ./niri.nix
    ./calendar.nix
    ./dms.nix
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
      playerctl
      libnotify
    ];

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

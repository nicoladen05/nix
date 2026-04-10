{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

let
  menus = import ./menus.nix { inherit pkgs; };
in
{
  imports = [
    ./brightness.nix
    ./quickshell
    ./wlsunset.nix
  ];

  options = {
    home-manager.niri.enable = lib.mkEnableOption "enable niri";
  };

  config = lib.mkIf config.home-manager.niri.enable {
    nixpkgs.overlays = [ inputs.quickshell.overlays.default ];

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
    home.file.".config/niri/wallpaper.jpg".source = ./wallpaper.jpg;

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = lib.mkForce "monospace:size=12";
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
    };

    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 60;
          command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
        }
      ];
    };

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

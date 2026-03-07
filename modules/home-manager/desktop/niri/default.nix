{
  lib,
  pkgs,
  config,
  ...
}:

let
  niriPowerMenu = pkgs.writeShellScriptBin "niri-power-menu" ''
    #!/usr/bin/env bash

    set -euo pipefail

    selected="$(printf '%s\n' 'Sleep' 'Logout' 'Shutdown' 'Restart' | fuzzel --dmenu --prompt 'Power: ')"

    case "$selected" in
      Sleep)
        systemctl suspend
        ;;
      Logout)
        niri msg action quit
        ;;
      Shutdown)
        systemctl poweroff
        ;;
      Restart)
        systemctl reboot
        ;;
    esac
  '';
in
{
  imports = [
    ./brightness.nix
    ./wlsunset.nix
  ];

  options = {
    home-manager.niri.enable = lib.mkEnableOption "enable niri";
  };

  config = lib.mkIf config.home-manager.niri.enable {
    home.packages = with pkgs; [
      niri
      xwayland-satellite
      wl-clipboard
      swaybg
      playerctl
      niriPowerMenu
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
          command = "niri msg action power-off-monitors";
        }
      ];
    };
  };
}

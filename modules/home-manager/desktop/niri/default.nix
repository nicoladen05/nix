{
  lib,
  pkgs,
  config,
  ...
}:

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

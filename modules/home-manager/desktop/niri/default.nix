{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./brightness.nix
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
      fuzzel
      mako
    ];

    home.file.".config/niri/config.kdl".source = ./config.kdl;
    home.file.".config/niri/wallpaper.jpg".source = ./wallpaper.jpg;

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

{ lib, pkgs, ... }:

{
  imports = [
    ./nerdfonts.nix
  ];

  programs.alacritty = {
    enable = true;

    settings = {

      window = {
        padding.x = 20;
        padding.y = 20;

        opacity = 0.8;
      };

      font = {
        normal.family = "Iosevka Nerd Font";
        size = 14;
      };

      cursor = {
        style.shape = "Beam";
      };
    };
  };
}

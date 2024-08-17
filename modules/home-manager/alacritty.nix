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

        opacity = 1;
      };

      font = {
        normal.family = "Iosevka Nerd Font";
        size = 12;
      };

      cursor = {
        style.shape = "Beam";
      };
    };
  };
}

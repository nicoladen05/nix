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
      };

      cursor = {
        style.shape = "Beam";
      };
    };
  };
}

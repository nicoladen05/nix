{ lib, pkgs, ...}:

{
  stylix.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml"

  stylix.image = /home/nico/Downloads/pexels-david-bartus-43782-4418939.jpg
}

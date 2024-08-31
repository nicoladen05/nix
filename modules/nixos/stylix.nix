{ lib, pkgs, ...}:

{
  stylix.enable = true;

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

  stylix.base16Scheme = {
    base00 = "151515";
    base01 = "171717";
    base02 = "191919";
    base03 = "212121";
    base04 = "404040";
    base05 = "E8E3E3";
    base06 = "E8E3E3";
    base07 = "E8E3E3";
    base08 = "B66467";
    base09 = "D9BC8C";
    base0A = "D9BC8C";
    base0B = "8C977D";
    base0C = "8AA6A2";
    base0D = "8AA6A2";
    base0E = "A988B0";
    base0F = "B66467";
  };

  stylix.image = /home/nico/pics/wal/wall.png;


  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Ice";
  stylix.cursor.size = 28;

  stylix.opacity = {
    terminal = 0.9;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; };
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
  };

  stylix.fonts.sizes = {
    terminal = 13;
    desktop = 12;
    applications = 11;
  };
}

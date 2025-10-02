{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:

let
  wallpaper = pkgs.fetchurl {
    url = "${config.desktop.stylix.wallpaper}";
    sha256 = "${config.desktop.stylix.wallpaperHash}}";
  };
in
{
  options = {
    desktop.stylix.enable = lib.mkEnableOption "enable stylix";

    desktop.stylix.colorScheme = lib.mkOption {
      type = lib.types.str;
      default = "catppuccin-macchiato";
      example = "catppuccin-macchiato";
    };

    desktop.stylix.wallpaper = lib.mkOption {
      type = lib.types.str;
    };

    desktop.stylix.wallpaperHash = lib.mkOption {
      type = lib.types.str;
      example = "sha256-NduOrnuMG7HcSLVH6Cj6/TIs/fL2kC1gq+O6IGOiEn8=";
    };
  };

  config = lib.mkIf config.desktop.stylix.enable {
    # Generate colorscheme with matugen
    programs.matugen = {
      enable = true;
      variant = "dark";
      inherit wallpaper;
    };

    stylix.enable = true;
    stylix.targets.console.enable = false;

    stylix.targets.nvf = {
      enable = true;
      transparentBackground = true;
    };

    stylix.polarity = "dark";

    # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.desktop.stylix.colorScheme}.yaml";

    # stylix.base16Scheme = {
    #   base00 = "151515";
    #   base01 = "424242";
    #   base02 = "8C977D";
    #   base03 = "D9BC8C";
    #   base04 = "8DA3B9";
    #   base05 = "E8E3E3";
    #   base06 = "A988B0";
    #   base07 = "E8E3E3";
    #   base08 = "B66467";
    #   base09 = "D9BC8C";
    #   base0A = "D9BC8C";
    #   base0B = "8C977D";
    #   base0C = "8AA6A2";
    #   base0D = "8DA3B9";
    #   base0E = "A988B0";
    #   base0F = "B66467";
    # };

    stylix.image = wallpaper;

    # stylix.cursor.package = pkgs.banana-cursor;
    # stylix.cursor.name = "Banana";
    # stylix.cursor.size = 48;

    stylix.cursor.package = pkgs.apple-cursor;
    stylix.cursor.name = "macOS";
    stylix.cursor.size = 28;

    stylix.opacity = {
      terminal = 1.0;
      applications = 1.0;
    };

    stylix.fonts = {
      monospace = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };
      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };
    };

    stylix.fonts.sizes = {
      terminal = 13;
      desktop = 12;
      applications = 11;
    };
  };
}

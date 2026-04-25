{
  lib,
  pkgs,
  config,
  ...
}:
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
    stylix.enable = true;
    stylix.targets.console.enable = false;

    stylix.targets.nvf = {
      enable = true;
      transparentBackground = true;
    };

    stylix.polarity = "dark";

    # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.desktop.stylix.colorScheme}.yaml";

    stylix.base16Scheme = {
      base00 = "0E1513";
      base01 = "0E1313";
      base02 = "161C1B";
      base03 = "1D2524";
      base04 = "BEC9C5";
      base05 = "DDE4E1";
      base06 = "333F3D";
      base07 = "3B4846";
      base08 = "CF6E00";
      base09 = "B87B32";
      base0A = "2F9788";
      base0B = "609700";
      base0C = "4E8EBD";
      base0D = "009989";
      base0E = "0090D3";
      base0F = "474A49";
    };

    stylix.image = pkgs.fetchurl {
      url = "${config.desktop.stylix.wallpaper}";
      hash = "${config.desktop.stylix.wallpaperHash}";
    };

    stylix.cursor.package = pkgs.apple-cursor;
    stylix.cursor.name = "macOS";
    stylix.cursor.size = 24;

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
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.inter;
        name = "Inter";
      };
    };

    stylix.fonts.sizes = {
      terminal = 12;
      desktop = 10;
      applications = 10;
    };
  };
}

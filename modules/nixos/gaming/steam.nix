{ pkgs, lib, config, ... }:

{
  options = {
    gaming.steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.gaming.steam.enable {
    programs.steam = {
      enable = true;
      package = pkgs.steam;
    };

    environment.systemPackages = with pkgs; [
      mangohud
      protonup-ng
      lutris
    ];

    programs.gamemode = {
      enable = true;
    };
  };
}

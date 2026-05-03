{
  pkgs,
  lib,
  config,
  ...
}:

{
  options = {
    gaming.steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.gaming.steam.enable {
    programs = {
      steam = {
        enable = true;
        package = pkgs.steam;
        localNetworkGameTransfers.openFirewall = true;
      };

      gamemode = {
        enable = true;
      };

      # gamescope = {
      #   enable = true;
      #   capSysNice = true;
      # };
    };

    environment.systemPackages = with pkgs; [
      mangohud
    ];
  };
}

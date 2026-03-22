{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.gaming.jovian;
in
{
  imports = [
    inputs.jovian.nixosModules.default
  ];

  options.gaming.jovian = {
    enable = lib.mkEnableOption "SteamOS-like Jovian specialisation";
  };

  config = lib.mkIf cfg.enable {
    specialisation.jovian.configuration = {
      jovian = {
        steam = {
          enable = true;
          autoStart = true;
          desktopSession = "niri";
          user = config.system.userName;
        };

        steamos = {
          useSteamOSConfig = true;
          enableBluetoothConfig = config.system.bluetooth.enable;
        };
      };
    };
  };
}

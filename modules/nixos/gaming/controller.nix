{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gaming.controller.xbox.enable = lib.mkEnableOption "enable xbox one controller";
  };

  config = lib.mkIf config.gaming.controller.xbox.enable {
    hardware.xpadneo.enable = true;

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
      '';
    };
  };
}

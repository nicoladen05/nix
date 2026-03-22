{ lib, config, ... }:

{
  options = {
    system.nvidia.enable = lib.mkEnableOption "enable the nvidia driver module";
  };

  config = lib.mkIf config.system.nvidia.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
  };
}

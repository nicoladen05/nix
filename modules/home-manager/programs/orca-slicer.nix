{
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    home-manager.orca-slicer.enable = lib.mkEnableOption "enable orca-slicer with config";
  };

  config = lib.mkIf config.home-manager.orca-slicer.enable {
    home.packages = [
      pkgs.orca-slicer
    ];
  };
}

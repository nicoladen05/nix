{
  config,
  lib,
  ...
}:
{
  imports = [
    ./assetto-corsa
    ./steam.nix
    ./controller.nix
    ./jovian
  ];

  options = {
    gaming.enable = lib.mkEnableOption "Enable a gaming environment";
  };

  config = lib.mkIf config.gaming.enable {
    gaming.steam.enable = true;
  };
}

{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

{
  options = {
    system.cachy.enable = lib.mkEnableOption "enable cachyos kernel and optimizations";
  };

  config = lib.mkIf config.system.cachy.enable {
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.default
    ];

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    nix.settings = {
      substituters = [ "https://attic.xuyh0120.win/lantian" ];
      trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
    };
  };
}

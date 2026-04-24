{ pkgs, lib, ... }:

{
  imports = [
    ./vfio.nix
    ./docker.nix
  ];
}

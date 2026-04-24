{ pkgs, lib, ... }:

{
  imports = [
    ./desktop
    ./gaming
    ./system
    ./nvf
    ./programs
    ./scripts
    ./virtualisation

    ./packages.nix
  ];
}

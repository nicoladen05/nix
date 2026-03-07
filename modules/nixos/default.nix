{ pkgs, lib, ... }:

{
  imports = [
    ./desktop
    ./gaming
    ./system
    ./nvf
    ./programs
    ./scripts

    ./packages.nix
  ];
}

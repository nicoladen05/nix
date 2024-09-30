{ pkgs, lib, inputs, ... }:

{
  inputs.nixvim.homeManagerModules.nixvim = {
    enable = true;
    defaultEditor = false;
  };
}

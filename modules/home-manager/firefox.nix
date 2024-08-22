{ lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    profiles.nico = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        bitwarden
        ublock-origin
      ];
    };
  };
}

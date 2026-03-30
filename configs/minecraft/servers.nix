{ pkgs, ... }:

let
  whitelist = import ./whitelist.nix;
  mods = import ./mods.nix { inherit pkgs; };
  joinedWhitelist = whitelist.default // whitelist.luca;
in
{
  jakob_modded = {
    host = "vps";
    domain = "mc.nicoladen.dev";
    type = "neoforge";
    version = "1.21.1";
    ram = "4G";
    whitelist = joinedWhitelist;
    mods = {
      enable = true;
      mods = mods.default // {
        bbl-casting = mods.bbl-casting;
        ultimate-plane-mod = mods.ultimate-plane-mod;
      };
    };
  };
}

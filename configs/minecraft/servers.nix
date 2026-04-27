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

    mods = with mods.v_1_21_1; {
      enable = true;
      mods = default // cheaty // {
        inherit bbl-casting;
        inherit bblcore;
        inherit car;
        inherit ciggycraft;
        inherit jetpack;
        inherit many-more-ores-and-crafts;
        inherit ultimate-plane-mod;
      };
    };
  };

  jonas = {
    host = "vps";
    domain = "mc2.nicoladen.dev";
    port = 25566;
    type = "fabric";
    version = "26.1";
    ram = "4G";

    properties.gamemode = "creative";

    mods = with mods.latest; {
      enable = true;
      mods = default // building // {
        inherit macaws-furniture;
        inherit motion-capture;
      };
    };
  };
}

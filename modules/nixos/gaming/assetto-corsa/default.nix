{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.assetto-corsa;

  assettoCorsaInstall = pkgs.writeShellApplication {
    name = "assetto-corsa-install";
    runtimeInputs = with pkgs; [
      cabextract
      coreutils
      findutils
      gawk
      glib
      gnugrep
      gnused
      p7zip
      procps
      unzip
      wget
      protontricks
      winetricks
      xdg-utils
    ];
    text = ''
      export GE_VERSION=${lib.escapeShellArg cfg.geVersion}
      export CSP_VERSION=${lib.escapeShellArg cfg.cspVersion}
      export INSTALL_DXVK_BY_DEFAULT=${if cfg.installDXVKByDefault then "1" else "0"}

      ${builtins.readFile ./install.sh}
    '';
  };
in
{
  options.gaming.assetto-corsa = {
    enable = lib.mkEnableOption "Enable packages required for running Assetto Corsa";

    geVersion = lib.mkOption {
      type = lib.types.str;
      default = "9-20";
      example = "9-25";
      description = "Preferred Proton-GE version shown by the setup helper.";
    };

    cspVersion = lib.mkOption {
      type = lib.types.str;
      default = "0.2.11";
      example = "0.2.12";
      description = "CSP version installed by the setup helper.";
    };

    installDXVKByDefault = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether the setup helper should suggest DXVK installation by default.";
    };
  };

  config = lib.mkIf cfg.enable {
    gaming.steam.enable = true;

    programs.steam.extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

    programs.steam.protontricks.enable = true;

    environment.systemPackages = with pkgs; [
      assettoCorsaInstall
      mangohud
      protonup-ng
    ];
  };
}

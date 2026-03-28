{
  lib,
  pkgs,
  config,
  ...
}:

let
  stylixColors = config.lib.stylix.colors;
  quickshellTheme = pkgs.replaceVars ./quickshell/Theme.qml {
    base00 = "#${stylixColors.base00}";
    base01 = "#${stylixColors.base01}";
    base03 = "#${stylixColors.base03}";
    base05 = "#${stylixColors.base05}";
    base0D = "#${stylixColors.base0D}";
    base0E = "#${stylixColors.base0E}";
  };
in
{
  config = lib.mkIf config.home-manager.niri.enable {
    home.packages = with pkgs; [
      quickshell
    ];

    xdg.configFile."quickshell/shell.qml".source = ./quickshell/shell.qml;
    xdg.configFile."quickshell/Bar.qml".source = ./quickshell/Bar.qml;
    xdg.configFile."quickshell/Clock.qml".source = ./quickshell/Clock.qml;
    xdg.configFile."quickshell/qmldir".source = ./quickshell/qmldir;
    xdg.configFile."quickshell/Theme.qml".source = quickshellTheme;

    systemd.user.services.quickshell = {
      Unit = {
        Description = "Quickshell session components";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${pkgs.quickshell}/bin/qs -p ${config.xdg.configHome}/quickshell";
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}

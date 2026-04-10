{
  lib,
  pkgs,
  config,
  ...
}:

let
  stylixColors = config.lib.stylix.colors;
  quickshellLauncherToggle = pkgs.writeShellScriptBin "quickshell-launcher-toggle" ''
    if ! ${pkgs.quickshell}/bin/qs ipc call launcher toggle >/dev/null 2>&1; then
      systemctl --user restart quickshell >/dev/null 2>&1 || true

      for _ in $(seq 1 20); do
        if ${pkgs.quickshell}/bin/qs ipc call launcher show >/dev/null 2>&1; then
          exit 0
        fi

        sleep 0.1
      done

      exit 1
    fi
  '';
  quickshellBar = pkgs.replaceVars ./Bar.qml {
    niri = "${pkgs.niri}/bin/niri";
    nmcli = "${pkgs.networkmanager}/bin/nmcli";
  };
  quickshellTheme = pkgs.replaceVars ./Theme.qml {
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
      quickshellLauncherToggle
    ];

    xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
    xdg.configFile."quickshell/Bar.qml".source = quickshellBar;
    xdg.configFile."quickshell/Clock.qml".source = ./Clock.qml;
    xdg.configFile."quickshell/qmldir".source = ./qmldir;
    xdg.configFile."quickshell/Theme.qml".source = quickshellTheme;
    xdg.configFile."quickshell/Launcher.qml".source = ./Launcher.qml;

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

{
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri

    inputs.danksearch.homeModules.default
  ];

  config = lib.mkIf config.home-manager.niri.enable {

    programs.dank-material-shell = {
      enable = true;

      niri = {
        enableSpawn = true;
        includes = {
          enable = false;
          override = false;
        };
      };

      enableSystemMonitoring = true;
      enableVPN = true;
      enableClipboardPaste = true;
      enableCalendarEvents = true;

      settings = {
        scrollTitleEnabled = false;
        audioVisualizerEnabled = false;
        centeringMode = "geometric";

        acMonitorTimeout = 60;
        acLockTimeout = 300;
        acSuspendTimeout = 1800;
        lockBeforeSuspend = true;

        lockScreenNotificationMode = 2;
        notificationCompactMode = true;

        powerMenuDefaultAction = "lock";

        blurWallpaperOnOverview = true;

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            leftWidgets = [
              {
                id = "clock";
                enabled = true;
                clockCompactMode = false;
              }
              {
                id = "weather";
                enabled = true;
              }
              {
                id = "music";
                enabled = true;
                mediaSize = 1;
              }
            ];
            centerWidgets = [
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
            ];
            rightWidgets = [
              {
                id = "privacyIndicator";
                enabled = true;
              }
              {
                id = "systemTray";
                enabled = true;
              }
              {
                id = "notificationButton";
                enabled = true;
              }
              {
                id = "controlCenterButton";
                enabled = true;
                showBatteryIcon = false;
                showScreenSharingIcon = false;
              }
            ];
            spacing = 5;
            innerPadding = 4;
            bottomGap = 0;
            transparency = 1.0;
            widgetTransparency = 1.0;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1.0;
            borderThickness = 1;
            fontScale = 1.0;
            autoHide = true;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeWidgetIcons = false;
            shadowIntensity = 0;
            widgetOutlineEnabled = false;
          }
        ];

        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "plugin_nextBootSelector";
            enabled = true;
            width = 50;
          }
          {
            id = "builtin_vpn";
            enabled = true;
            width = 50;
          }
        ];
      };

      session = {
        weatherLocation = "Ehmen, Niedersachsen";
        weatherCoordinates = "52.3990844,10.6992485";

        hiddenTrayIds = [
          "blueman::Bluetooth Active"
        ];
      };
    };

    programs.dsearch.enable = true;

    # Use DMS polkit agent instead of auto-starting niri-flake-polkit.
    systemd.user.services.niri-flake-polkit.Install.WantedBy = lib.mkForce [ ];
  };
}

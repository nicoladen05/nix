{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.home-manager.niri.enable {
    home.packages = with pkgs; [
      libnotify
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        settingsVersion = 59;
        bar = {
          barType = "floating";
          position = "top";
          monitors = [ ];
          density = "default";
          showOutline = false;
          showCapsule = true;
          capsuleColorKey = "none";
          widgetSpacing = 6;
          contentPadding = 2;
          enableExclusionZoneInset = true;
          marginVertical = 4;
          marginHorizontal = 4;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = true;
          hideOnOverview = true;
          displayMode = "auto_hide";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;
          widgets = {
            left = [
              {
                clockColor = "none";
                formatHorizontal = "HH:mm ddd MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
              }
              {
                compactMode = false;
                hideMode = "hidden";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 200;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = false;
                showVisualizer = false;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "linear";
              }
            ];
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                hideUnoccupied = false;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "none";
                occupiedColor = "none";
                pillSize = 0.6;
                showApplications = true;
                showApplicationsHover = true;
                showBadge = false;
                showLabelsOnlyWhenOccupied = true;
              }
            ];
            right = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }
              {
                defaultSettings = {
                  activeColor = "primary";
                  enableToast = true;
                  hideInactive = false;
                  iconSpacing = 4;
                  inactiveColor = "none";
                  micFilterRegex = "";
                  removeMargins = false;
                };
                id = "plugin:privacy-indicator";
              }
              {
                hideWhenZero = false;
                hideWhenZeroUnread = false;
                iconColor = "none";
                id = "NotificationHistory";
                showUnreadBadge = true;
                unreadBadgeColor = "primary";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }
              {
                applyToAllMonitors = false;
                displayMode = "onhover";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }
              {
                defaultSettings = {
                  connectedColor = "primary";
                  disableToastNotifications = false;
                  disconnectedColor = "none";
                  displayMode = "onhover";
                };
                id = "plugin:network-manager-vpn";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "pwvucontrol || pavucontrol";
                textColor = "none";
              }
              {
                deviceNativePath = "__default__";
                displayMode = "graphic";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = false;
                showPowerProfiles = false;
              }
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "adjustments-horizontal";
                id = "ControlCenter";
                useDistroLogo = false;
              }
            ];
          };
          mouseWheelAction = "none";
          reverseScroll = false;
          mouseWheelWrap = true;
          middleClickAction = "none";
          middleClickFollowMouse = false;
          middleClickCommand = "";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [ ];
        };
        general = {
          avatarImage = "/home/nico/.face";
          showScreenCorners = false;
          forceBlackScreenCorners = true;
          scaleRatio = 1;
          radiusRatio = 1;
          iRadiusRatio = 1;
          boxRadiusRatio = 1;
          screenRadiusRatio = 1;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = true;
          lockScreenAnimations = true;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = false;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = false;
          enableShadows = false;
          enableBlurBehind = true;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          enableLockScreenCountdown = false;
          lockScreenCountdownDuration = 10000;
          autoStartAuth = false;
          allowPasswordWithFprintd = false;
          clockStyle = "custom";
          clockFormat = "HH:mm ";
          passwordChars = true;
          lockScreenMonitors = [ ];
          lockScreenBlur = 0.1;
          lockScreenTint = 0;
          keybinds = {
            keyUp = [ "Up" ];
            keyDown = [ "Down" ];
            keyLeft = [ "Left" ];
            keyRight = [ "Right" ];
            keyEnter = [
              "Return"
              "Enter"
            ];
            keyEscape = [ "Esc" ];
            keyRemove = [ "Del" ];
          };
          reverseScroll = false;
          smoothScrollEnabled = false;
        };
        ui = {
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = false;
          boxBorderEnabled = false;
          translucentWidgets = false;
          panelsAttachedToBar = true;
          settingsPanelMode = "window";
          settingsPanelSideBarCardStyle = true;
        };
        location = {
          name = "";
          weatherEnabled = true;
          weatherShowEffects = true;
          weatherTaliaMascotAlways = false;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = false;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = false;
          autoLocate = false;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        wallpaper = {
          enabled = false;
          overviewEnabled = true;
          directory = "/home/nico/Pictures/Wallpapers";
          monitorDirectories = [ ];
          enableMultiMonitorDirectories = false;
          showHiddenFiles = false;
          viewMode = "single";
          setWallpaperOnAllMonitors = true;
          linkLightAndDarkWallpapers = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 300;
          transitionDuration = 1500;
          transitionType = [
            "fade"
            "disc"
            "stripes"
            "wipe"
            "pixelate"
            "honeycomb"
          ];
          skipStartupTransition = false;
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useOriginalImages = false;
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
          favorites = [ ];
        };
        appLauncher = {
          enableClipboardHistory = false;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          enableClipboardSmartIcons = true;
          enableClipboardChips = true;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          position = "center";
          pinnedApps = [ ];
          sortByMostUsed = true;
          terminalCommand = "alacritty -e";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "list";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "";
          overviewLayer = false;
          density = "default";
        };
        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";
          shortcuts = {
            left = [
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "NoctaliaPerformance";
              }
              {
                defaultSettings = {
                  compactMode = false;
                  defaultDuration = 0;
                  iconColor = "none";
                  textColor = "none";
                };
                id = "plugin:timer";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
              {
                defaultSettings = {
                  audioCodec = "opus";
                  audioSource = "default_output";
                  colorRange = "limited";
                  copyToClipboard = false;
                  customReplayDuration = "30";
                  directory = "";
                  filenamePattern = "recording_yyyyMMdd_HHmmss";
                  frameRate = "60";
                  hideInactive = false;
                  iconColor = "none";
                  quality = "very_high";
                  replayDuration = "30";
                  replayEnabled = false;
                  replayStorage = "ram";
                  resolution = "original";
                  restorePortalSession = false;
                  showCursor = true;
                  videoCodec = "h264";
                  videoSource = "portal";
                };
                id = "plugin:screen-recorder";
              }
            ];
          };
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 5;
          enableDgpuMonitoring = false;
          useCustomColors = false;
          warningColor = "";
          criticalColor = "";
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
        };
        noctaliaPerformance = {
          disableWallpaper = true;
          disableDesktopWidgets = true;
        };
        dock = {
          enabled = false;
          position = "bottom";
          displayMode = "always_visible";
          dockType = "floating";
          floatingRatio = 1;
          size = 1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          showLauncherIcon = false;
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          launcherIcon = "";
          launcherIconColor = "none";
          pinnedStatic = false;
          inactiveIndicators = false;
          groupApps = false;
          groupContextMenuMode = "extended";
          groupClickAction = "cycle";
          groupIndicatorStyle = "dots";
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = false;
          indicatorThickness = 3;
          indicatorColor = "primary";
        };
        network = {
          bluetoothRssiPollingEnabled = false;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };
        sessionMenu = {
          enableCountdown = false;
          countdownDuration = 10000;
          position = "center";
          showHeader = true;
          showKeybinds = false;
          largeButtonsStyle = true;
          largeButtonsLayout = "single-row";
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }
            {
              action = "logout";
              command = "niri msg action quit";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "4";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "5";
            }
            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };
        notifications = {
          enabled = true;
          enableMarkdown = false;
          density = "default";
          monitors = [ ];
          location = "top_right";
          overlayLayer = true;
          respectExpireTimeout = true;
          lowUrgencyDuration = 3;
          normalUrgencyDuration = 5;
          criticalUrgencyDuration = 15;
          clearDismissed = true;
          saveToHistory = {
            low = false;
            normal = true;
            critical = true;
          };
          sounds = {
            enabled = true;
            volume = 0.5;
            separateSounds = false;
            criticalSoundFile = "";
            normalSoundFile = "";
            lowSoundFile = "";
            excludedApps = "discord,firefox,chrome,chromium,edge";
          };
          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
          overlayLayer = true;
          enabledTypes = [
            0
            1
            2
          ];
          monitors = [ ];
        };
        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 30;
          visualizerType = "none";
          spectrumMirrored = true;
          mprisBlacklist = [ ];
          preferredPlayer = "spotify";
          volumeFeedback = true;
          volumeFeedbackSoundFile = "";
        };
        brightness = {
          brightnessStep = 5;
          enforceMinimum = false;
          enableDdcSupport = true;
          backlightDeviceMappings = [ ];
        };
        colorSchemes = {
          useWallpaperColors = false;
          predefinedScheme = "Noctalia-default";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "tonal-spot";
          monitorForColors = "";
          syncGsettings = true;
        };
        templates = {
          activeTemplates = [ ];
          enableUserTheming = false;
        };
        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = false;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };
        hooks = {
          enabled = false;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
          colorGeneration = "";
        };
        plugins = {
          autoUpdate = false;
          notifyUpdates = true;
        };
        idle = {
          enabled = true;
          screenOffTimeout = 60;
          lockTimeout = 90;
          suspendTimeout = 1800;
          fadeDuration = 5;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";
          customCommands = "[]";
        };
        desktopWidgets = {
          enabled = false;
          overviewEnabled = true;
          gridSnap = false;
          gridSnapScale = false;
          monitorWidgets = [ ];
        };
      };
    };
  };
}

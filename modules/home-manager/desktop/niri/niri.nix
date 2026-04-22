{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.home-manager.niri.enable {
    programs.niri.package = pkgs.niri;

    programs.niri.settings = {
      prefer-no-csd = true;

      cursor = {
        theme = "macOS";
        size = 24;
        hide-when-typing = true;
        hide-after-inactive-ms = 3000;
      };

      input = {
        keyboard = {
          repeat-rate = 35;
          repeat-delay = 250;
          xkb = {
            layout = "us";
            options = "compose:caps";
          };
          numlock = true;
        };

        touchpad = {
          tap = true;
          natural-scroll = true;
        };

        mouse.accel-profile = "flat";

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
      };

      outputs."DP-3" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 239.996;
        };
        variable-refresh-rate = true;
        scale = 1.75;
        transform.rotation = 0;
        position = {
          x = 0;
          y = 0;
        };
      };

      layout = {
        gaps = 5;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        default-column-width.proportion = 0.5;

        focus-ring = {
          enable = true;
          width = 1;
          active.color = lib.mkForce "#5f6368";
          inactive.color = lib.mkForce "#505050";
        };

        border = {
          enable = false;
          width = 1;
          active.color = lib.mkForce "#8f949b";
          inactive.color = lib.mkForce "#5f6368";
          urgent.color = lib.mkForce "#9b0000";
        };

        shadow = {
          enable = true;
          softness = 20;
          spread = 0;
          offset = {
            x = 0;
            y = 5;
          };
          color = "rgba(0, 0, 0, 0.3)";
        };
      };

      spawn-at-startup = [
        { sh = "swaybg -i ~/.config/niri/wallpaper.jpg -m fill"; }
        { argv = [ "noctalia-shell" ]; }
      ];

      hotkey-overlay.skip-at-startup = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      window-rules = [
        {
          matches = [
            { app-id = "^org\\.wezfurlong\\.wezterm$"; }
          ];
          default-column-width = { };
        }
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          geometry-corner-radius = {
            top-left = 15.0;
            top-right = 15.0;
            bottom-left = 15.0;
            bottom-right = 15.0;
          };
          clip-to-geometry = true;
        }
      ];

      binds =
        with config.lib.niri.actions;
        let
          dms-ipc = spawn "dms" "ipc";
        in
        {
          "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

          "Mod+Return" = {
            hotkey-overlay.title = "Open a Terminal: alacritty";
            action.spawn = "alacritty";
          };
          "Mod+Space" = {
            action = dms-ipc "spotlight" "toggle";
            hotkey-overlay.title = "Toggle Application Launcher";
          };
          "Mod+Comma" = {
            action = dms-ipc "settings" "toggle";
            hotkey-overlay.title = "Toggle Settings";
          };
          "Mod+Period" = {
            action = dms-ipc "notifications" "toggle";
            hotkey-overlay.title = "Toggle Notification Center";
          };
          "Mod+P" = {
            action = dms-ipc "notepad" "toggle";
            hotkey-overlay.title = "Toggle Notepad";
          };
          "Super+Shift+L" = {
            hotkey-overlay.title = "Lock the Screen: Noctalia";
            action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "lockScreen"
              "lock"
            ];
          };
          "Super+Alt+L" = {
            action = dms-ipc "lock" "lock";
            hotkey-overlay.title = "Toggle Lock Screen";
          };
          "Mod+X" = {
            action = dms-ipc "powermenu" "toggle";
            hotkey-overlay.title = "Toggle Power Menu";
          };

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "increment" "3";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "decrement" "3";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "mute";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action = dms-ipc "audio" "micmute";
          };

          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn-sh = "playerctl play-pause";
          };
          "XF86AudioStop" = {
            allow-when-locked = true;
            action.spawn-sh = "playerctl stop";
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn-sh = "playerctl previous";
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn-sh = "playerctl next";
          };

          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "increment" "5" "";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action = dms-ipc "brightness" "decrement" "5" "";
          };
          "Mod+Alt+N" = {
            allow-when-locked = true;
            action = dms-ipc "night" "toggle";
            hotkey-overlay.title = "Toggle Night Mode";
          };

          "Mod+O" = {
            repeat = false;
            action.toggle-overview = [ ];
          };

          "Mod+Q" = {
            repeat = false;
            action.close-window = [ ];
          };

          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Down".action.focus-window-or-workspace-down = [ ];
          "Mod+Up".action.focus-window-or-workspace-up = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+H".action.focus-column-left = [ ];
          "Mod+N".action.focus-window-or-workspace-down = [ ];
          "Mod+E".action.focus-window-or-workspace-up = [ ];
          "Mod+I".action.focus-column-right = [ ];

          "Mod+Shift+Left".action.move-column-left = [ ];
          "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = [ ];
          "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = [ ];
          "Mod+Shift+Right".action.move-column-right = [ ];
          "Mod+Shift+H".action.move-column-left = [ ];
          "Mod+Shift+N".action.move-window-down-or-to-workspace-down = [ ];
          "Mod+Shift+E".action.move-window-up-or-to-workspace-up = [ ];
          "Mod+Shift+I".action.move-column-right = [ ];

          "Mod+Home".action.focus-column-first = [ ];
          "Mod+End".action.focus-column-last = [ ];
          "Mod+Shift+Home".action.move-column-to-first = [ ];
          "Mod+Shift+End".action.move-column-to-last = [ ];

          "Mod+Ctrl+Left".action.focus-monitor-left = [ ];
          "Mod+Ctrl+Down".action.focus-monitor-down = [ ];
          "Mod+Ctrl+Up".action.focus-monitor-up = [ ];
          "Mod+Ctrl+Right".action.focus-monitor-right = [ ];
          "Mod+Ctrl+H".action.focus-monitor-left = [ ];
          "Mod+Ctrl+N".action.focus-monitor-down = [ ];
          "Mod+Ctrl+E".action.focus-monitor-up = [ ];
          "Mod+Ctrl+I".action.focus-monitor-right = [ ];

          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+N".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+E".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+I".action.move-column-to-monitor-right = [ ];

          "Mod+Page_Down".action.focus-workspace-down = [ ];
          "Mod+Page_Up".action.focus-workspace-up = [ ];
          "Mod+L".action.focus-workspace-down = [ ];
          "Mod+U".action.focus-workspace-up = [ ];
          "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [ ];
          "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [ ];
          "Mod+Shift+L".action.move-column-to-workspace-down = [ ];
          "Mod+Shift+U".action.move-column-to-workspace-up = [ ];

          "Mod+Ctrl+Page_Down".action.move-workspace-down = [ ];
          "Mod+Ctrl+Page_Up".action.move-workspace-up = [ ];
          "Mod+Ctrl+L".action.move-workspace-down = [ ];
          "Mod+Ctrl+U".action.move-workspace-up = [ ];

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = [ ];
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = [ ];
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = [ ];
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = [ ];
          };

          "Mod+WheelScrollRight".action.focus-column-right = [ ];
          "Mod+WheelScrollLeft".action.focus-column-left = [ ];
          "Mod+Shift+WheelScrollRight".action.move-column-right = [ ];
          "Mod+Shift+WheelScrollLeft".action.move-column-left = [ ];

          "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
          "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Shift+1".action.move-column-to-workspace = 1;
          "Mod+Shift+2".action.move-column-to-workspace = 2;
          "Mod+Shift+3".action.move-column-to-workspace = 3;
          "Mod+Shift+4".action.move-column-to-workspace = 4;
          "Mod+Shift+5".action.move-column-to-workspace = 5;
          "Mod+Shift+6".action.move-column-to-workspace = 6;
          "Mod+Shift+7".action.move-column-to-workspace = 7;
          "Mod+Shift+8".action.move-column-to-workspace = 8;
          "Mod+Shift+9".action.move-column-to-workspace = 9;

          "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
          "Mod+BracketRight".action.consume-or-expel-window-right = [ ];

          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+Shift+R".action.switch-preset-window-height = [ ];
          "Mod+Ctrl+R".action.reset-window-height = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];
          "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];
          "Mod+C".action.center-column = [ ];
          "Mod+Ctrl+C".action.center-visible-columns = [ ];
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Mod+V".action.toggle-window-floating = [ ];
          "Mod+Ctrl+V" = {
            action = dms-ipc "clipboard" "toggle";
            hotkey-overlay.title = "Toggle Clipboard Manager";
          };
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

          "Mod+W".action.spawn = "helium";
          "Mod+Shift+W".action.toggle-column-tabbed-display = [ ];

          "Mod+Shift+S".action.screenshot = [ ];
          "Mod+Shift+Ctrl+S".action.screenshot-screen = [ ];
          "Mod+Shift+Alt+S".action.screenshot-window = [ ];

          "Mod+Escape" = {
            action = dms-ipc "powermenu" "toggle";
            hotkey-overlay.title = "Toggle Power Menu";
          };
          "Mod+Shift+Escape" = {
            allow-inhibiting = false;
            action.toggle-keyboard-shortcuts-inhibit = [ ];
          };

          "Mod+Shift+Q".action.quit = [ ];
          "Ctrl+Alt+Delete".action.quit = [ ];
          "Mod+Shift+P".action.power-off-monitors = [ ];
        }
        // lib.optionalAttrs (config.programs.dank-material-shell.enableSystemMonitoring or false) {
          "Mod+M" = {
            action = dms-ipc "processlist" "toggle";
            hotkey-overlay.title = "Toggle Process List";
          };
        };
    };
  };
}

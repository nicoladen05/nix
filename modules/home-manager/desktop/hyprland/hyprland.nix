{
  lib,
  pkgs,
  config,
  ...
}:
let
  primaryMonitor =
    (builtins.head (builtins.filter (d: d.primary) config.home-manager.hyprland.displays)).display;
in
{
  imports = [
    ./mako.nix
    ./rofi.nix
    ./waybar.nix
    ./vicinae.nix
  ];

  options = {
    home-manager.hyprland.enable = lib.mkEnableOption "enable hyprland";

    home-manager.hyprland.displays = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            display = lib.mkOption {
              type = lib.types.str;
              example = "DP-6";
            };
            primary = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            resolution = lib.mkOption {
              type = lib.types.str;
              example = "2560x1440";
            };
            refreshRate = lib.mkOption {
              type = lib.types.int;
              example = 165;
            };
            offset = lib.mkOption {
              type = lib.types.str;
              default = "0x0";
            };
            scale = lib.mkOption {
              type = lib.types.str;
              default = "auto";
            };
            vrr = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            rotate = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
            };
          };
        }
      );
      apply =
        displays:
        let
          primaryDisplays = builtins.length (builtins.filter (d: d.primary) displays);
        in
        if primaryDisplays == 1 then
          displays
        else
          throw "Exactly one monitor must be configured as primary. Found ${toString primaryDisplays} primary monitors.";
    };
  };

  config = lib.mkIf config.home-manager.hyprland.enable {
    home-manager.mako.enable = true;
    home-manager.rofi.enable = true;
    home-manager.vicinae.enable = true;
    home-manager.waybar.enable = true;

    gtk.enable = true;
    gtk.iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
        };

        background = {
          path = lib.mkForce "/tmp/screenshot.png";
          blur_passes = 3;
          blur_size = 8;
        };

        input-field = {
          monitor = primaryMonitor;
          halign = "center";
          valign = "bottom";
          position = "0, 200";
        };

        label = [
          {
            monitor = primaryMonitor;
            text = "$TIME";
            font_size = 100;
            font_family = "JetBrainsMono Nerd Font";
            position = "0,200";
            halign = "center";
            valign = "center";
          }
          {
            monitor = primaryMonitor;
            text = "cmd[update:10000] date +'%a, %d. %b'";
            font_size = 24;
            font_family = "JetBrainsMono Nerd Font";
            position = "-80,80";
            halign = "center";
            valign = "center";
          }
          {
            monitor = primaryMonitor;
            text = "cmd[update:10000] weather-script";
            font_size = 24;
            font_family = "JetBrainsMono Nerd Font";
            position = "120,80";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
    };

    services.hyprsunset = {
      enable = true;
      settings = {
        max-gamma = 100;

        profile = [
          # Day
          {
            time = "7:00";
            identity = true;
          }
          # Wind-Down
          {
            time = "18:30";
            temperature = 5000;
          }
          {
            time = "19:00";
            temperature = 4500;
            gamma = 0.95;
          }
          {
            time = "19:30";
            temperature = 4000;
            gamma = 0.9;
          }
          # Night
          {
            time = "20:00";
            temperature = 3000;
            gamma = 0.7;
          }
        ];
      };
    };

    wayland.windowManager.hyprland.xwayland.enable = true;

    wayland.windowManager.hyprland.enable = true;

    wayland.windowManager.hyprland.settings = {
      monitor = lib.mkMerge [
        # "DP-6, 2560x1440@165, 0x0, 1, vrr, 1"
        # "HDMI-A-2, 1920x1080@75, -1080x0, 1, transform, 3"
        # "DP-6, addreserved, -6, 0, 0, 0"

        (lib.forEach config.home-manager.hyprland.displays (
          display:
          let
            vrrStr = if display.vrr then ", vrr, 2" else "";
            transformStr = if display.rotate != null then ", transform, ${toString display.rotate}" else "";
          in
          "${display.display}, ${display.resolution}@${toString display.refreshRate}, ${display.offset}, ${display.scale}${vrrStr}${transformStr}"
        ))
      ];

      "$terminal" = "alacritty";
      "$browser" = "librewolf";
      "$fileManager" = "yazi";
      "$menu" = "rofi -show drun -show-icons";

      exec-once = [
        "waybar &"
        "mako &"
      ];

      general = {
        gaps_in = 6;
        gaps_out = 16;

        border_size = 1;

        resize_on_border = true;

        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 4;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;

          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = lib.mkForce "0xee1a1a1a";
        };

      };

      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 0, 0, ease"
        ];
      };

      cursor = {
        inactive_timeout = 3;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
      };

      input = {
        kb_layout = "us";
        # kb_variant = "colemak";
        # kb_options = "caps:escape";

        repeat_delay = 300;
        repeat_rate = 50;

        follow_mouse = 1;

        sensitivity = -0.2;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = false;
        };
      };

      xwayland = {
        force_zero_scaling = true;
      };

      # gestures = {
      #   workspace_swipe = false;
      # };

      "$mainMod" = "SUPER";
      "$secondaryMod" = "ALT";
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, W, exec, $browser"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, exec, $menu"
        "ALT, Space, exec, vicinae toggle"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"

        # Move focus with mainMod + arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, h, movefocus, l"
        "$mainMod, i, movefocus, r"
        "$mainMod, e, movefocus, u"
        "$mainMod, n, movefocus, d"

        # Swap window with mainMod + SHIFT + Arrow Keys
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"

        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, i, movewindow, r"
        "$mainMod SHIFT, e, movewindow, u"
        "$mainMod SHIFT, n, movewindow, d"

        # Swap window with mainMod + CONTROL + Arrow Keys
        "$mainMod CONTROL, left, resizeactive, -50 0"
        "$mainMod CONTROL, right, resizeactive, 50 0"
        "$mainMod CONTROL, up, resizeactive, 0 -50"
        "$mainMod CONTROL, down, resizeactive, 0 50"

        "$mainMod CONTROL, h, resizeactive, -50 0"
        "$mainMod CONTROL, i, resizeactive, 50 0"
        "$mainMod CONTROL, e, resizeactive, 0 -50"
        "$mainMod CONTROL, n, resizeactive, 0 50"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Fullscreen
        "$mainMod, F, fullscreen, 1"
        "$mainMod SHIFT, F, fullscreen"

        # Float
        "$mainMod, g, workspaceopt, allfloat"

        # Example special workspace (scratchpad)
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        # Show/hide bar
        "$mainMod, B, exec, pgrep waybar && pkill waybar || waybar &"

        # Screenshots
        "CTRL SHIFT, 3, exec, hyprshot -m output -m active"
        "CTRL SHIFT, 4, exec, hyprshot -m region"
        "CTRL SHIFT, 5, exec, hyprshot -m window -m active"

        "$mainMod, Escape, exec, rofi-power-menu"

        ", code:121, exec, pamixer -t"
        ", code:122, exec, pamixer -d 5"
        ", code:123, exec, pamixer -i 5"

        ", code:173, exec, playerctl previous"
        ", code:172, exec, playerctl play-pause"
        ", code:171, exec, playerctl next"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$secondaryMod, mouse:272, movewindow"
        "$secondaryMod, mouse:273, resizewindow"
      ];

      # windowrulev2 = [
      #   "suppressevent maximize, class:.*"
      #   "noanim,class:^(ueberzugpp.*)"
      #   "float,class:^(ueberzugpp.*)"
      #   "workspace 8, class:spotify"
      #   "workspace 9, class:discord"
      # ];

      workspace = [
        "1, monitor:${primaryMonitor}"
        "2, monitor:${primaryMonitor}"
        "3, monitor:${primaryMonitor}"
        "4, monitor:${primaryMonitor}"
        "5, monitor:${primaryMonitor}"
        "6, monitor:${primaryMonitor}"
        "7, monitor:${primaryMonitor}"
        "8, monitor:${primaryMonitor}"
        "9, monitor:${primaryMonitor}"
        "9, monitor:${primaryMonitor}"
      ];
    };
  };
}

{ lib, pkgs, ... }:

{
  programs.hyprlock.enable = true;
  
  programs.hyprlock.settings = {
    background = [
      {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }
    ];
  };

  wayland.windowManager.hyprland.enable = true;
  
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-3, 2560x1440@165, 0x0, 1"
      "HDMI-A-1, 1920x1080@75, -1080x0, 1, transform, 3"
      "DP-3, addreserved, -10, 0, 0, 0"
      "HDMI-A-1, addreserved, -10, 0, 0, 0"
    ];


    "$terminal" = "alacritty";
    "$fileManager" = "dolphin";
    "$menu" = "rofi -show drun -show-icons";


    exec-once = [
      "swww init &"
      "waybar &"
      "dunst &"
    ];


    general = {
      gaps_in = 6;
      gaps_out = 16;

      border_size = 2;

      resize_on_border = false;

      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;

      blur = {
          enabled = true;
          size = 8;
          passes = 1;
          
          vibrancy = 0.1696;
      };
    };

    animations = {
      enabled = true;

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    
    dwindle = {
        pseudotile = true;
        preserve_split = true;
    };

    master = {
        new_status = "master";
    };

    misc =  { 
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
    };


    input = {
        kb_layout = "us";
        kb_variant = "colemak";
        kb_options = "caps:escape";

        follow_mouse = 1;

        sensitivity = -0.25;
        accel_profile = "flat";

        touchpad = {
            natural_scroll = false;
        };
    };

    gestures = {
        workspace_swipe = false;
    };


    "$mainMod" = "SUPER"; 
    bind = [
      "$mainMod, Return, exec, $terminal"
      "$mainMod, W, exec, firefox"
      "$mainMod, Q, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod SHIFT, Space, togglefloating,"
      "$mainMod, Space, exec, $menu"
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

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
    ];
    
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    windowrulev2 = "suppressevent maximize, class:.*";

  };
}

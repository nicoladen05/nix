{ lib, pkgs, ... }:

{
  programs.waybar.enable = true;

  programs.waybar.settings = {
    mainBar = {
      height = 30;

      modules-left = [ "clock" "custom/date" "custom/weather" ];
      modules-center = [ "hyprland/workspaces" ];
      modules-right = [ "network" "pulseaudio" ];

      clock = {
        format = "󰥔  {:%H:%M}";
      };

      "custom/date" = {
        exec = "date +'󰃭  %a, %d. %b'";
        interval = 60;
      };

      "custom/weather" = {
        exec = "curl 'wttr.in/?format=3' | awk '{print $3,$4}' | sed 's/+//'";
        interval = 3600;
      };

      network = {
        "format-disconnected" = "󰯡   Disconnected";
        "format-ethernet" = "󰈀   Hydrogen";
        "format-linked" = "󰖪  {essid} (No IP)";
        "format-wifi" = "󰖩  {essid}";
        "interval" = 1;
        "tooltip" = false;
      };

      pulseaudio = {
        format = "   {volume}%";
      };
    };
  };

  programs.waybar.style = ''
    * {
      font-size: 14px;
    }

    window#waybar {
      background-color: rgba(0,0,0,0);
    }

    tooltip label {
      padding: 3px 3px 3px 3px;
    }

    tooltip {
      padding: 10px 10px 10px 10px;
      border: 0px solid;
      border-radius: 8px;
    }

    #workspaces{
      border-radius: 8px;
      background-color: @base00;
      margin-left: 10px;
      margin-right: 10px;
      margin-top: 10px;
      margin-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }

    #workspaces button.active{
      background-color: @base05;
      color: @base00;
    }

    .modules-left #clock{
      border-radius: 8px;
      background-color: @base0D;
      color: @base00;
      margin-left: 16px;
      margin-right: 5px;
      margin-top: 10px;
      margin-bottom: 10px;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
      padding-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }
    
    .modules-left #custom-date{
      border-radius: 8px;
      background-color: @base0F;
      color: @base00;
      margin-left: 5px;
      margin-right: 5px;
      margin-top: 10px;
      margin-bottom: 10px;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
      padding-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }

    .modules-left #custom-weather{
      border-radius: 8px;
      background-color: @base0A;
      color: @base00;
      margin-left: 5px;
      margin-right: 5px;
      margin-top: 10px;
      margin-bottom: 10px;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
      padding-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }

    .modules-right #network {
      border-radius: 8px;
      background-color: @base08;
      color: @base00;
      margin-right: 5px;
      margin-left: 5px;
      margin-top: 10px;
      margin-bottom: 10px;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
      padding-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }

    .modules-right #pulseaudio{
      border-radius: 8px;
      background-color: @base0B;
      color: @base00;
      margin-right: 16px;
      margin-left: 5px;
      margin-top: 10px;
      margin-bottom: 10px;
      padding-left: 10px;
      padding-right: 10px;
      padding-top: 10px;
      padding-bottom: 10px;
      box-shadow: 0px 0px 6px -5px #000000;
    }

  '';

  services.playerctld.enable = true;
}

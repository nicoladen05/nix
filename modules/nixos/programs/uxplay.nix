{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.uxplay;
in
{
  options.programs.uxplay = {
    enable = lib.mkEnableOption "Enable uxplay";
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        userServices = true;
        domain = true;
        addresses = true;
        workstation = true;
      };
    };

    environment.systemPackages = with pkgs; [
      uxplay
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];

    networking.firewall = {
      allowedUDPPorts = [
        5353
        6000
        6001
        7011
      ];
      allowedTCPPorts = [
        7000
        7001
        7100
      ];
    };
  };
}

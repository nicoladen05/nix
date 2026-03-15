{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.system.openvpn;
in
{
  options.system.openvpn = {
    enable = lib.mkEnableOption "enable OpenVPN integration with NetworkManager";
    persistence.enable = lib.mkEnableOption "enable persisting vpn connection";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

      environment.systemPackages = [
        pkgs.openvpn
      ];
    })
    (
      if options ? environment.persistence then
        lib.mkIf (cfg.enable && cfg.persistence.enable) {
          environment.persistence."/persistent".directories = [
            "/etc/NetworkManager/system-connections"
            "/var/lib/NetworkManager"
          ];
        }
      else
        { }
    )
  ];
}

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
  options.system.openvpn.enable = lib.mkEnableOption "enable OpenVPN integration with NetworkManager";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

        environment.systemPackages = [
          pkgs.openvpn
        ];
      }

      (lib.mkIf (options ? environment.persistence) {
        environment.persistence."/persistent".directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/NetworkManager"
        ];
      })
    ]
  );
}

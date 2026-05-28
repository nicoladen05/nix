{ lib, config, ... }:

let
  cfg = config.system.security;
in
{
  options.system.security = {
    enable = lib.mkEnableOption "Enable security/hardening" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    # Harden ssh
    services.openssh.settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ config.system.userName ];
      MaxAuthTries = 3;
    };

    # Turn off the root password
    users.users.root.hashedPassword = null;
  };
}

{
  nixos-raspberrypi,
  config,
  ...
}:

let
  userName = "nico";
  hostName = "travelrouter";
in
{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.bluetooth
    usb-gadget-ethernet
    sd-image

    ../../modules/nixos
  ];

  system = {
    enable = true;
    sops.enable = true;
    boot.systemdBoot = false;

    inherit userName;
    inherit hostName;
    password = {
      enable = true;
      hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
    };

    passwordlessRebuild = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.kernelPackages.kernel.version
  ];
}

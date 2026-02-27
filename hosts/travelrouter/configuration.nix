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

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXGyUgkeoDxvW+FiwBHqPbtwzvyb5GosDgIaE3uBihImtMZTjEHVKWob8nkMqGqu+ga+axck5F1rwvIDcLufnin3N74D2R6xVa4VwC2DNHThzxoyfDvjxTqvaxAoqnQWLd3IyLKxTgnstdXsOwIgTKtqWcL5g5CvSpsHmxVSQVFlUXpuhM8F8jDr573dpCtBrD7fpkC64Q4hMtWUDch1DLleHLv9Jjf1GYe01sPvrRfzKC5pXnHSXiddOgyzDHnU+MK6vqbETGcrB89ENcFZUveJGON1KfwM9x3JCiP5IVz3Pxam72XKy0eRMUda2ZGgT7EP/KpJA+ESlkT58qf103KDRy71R0IlSi64o2ruoUP271rPoZsc/MUbvssbBvJyolVz6O54uQUs2sJMZMOFIecMeSs/NwxMi2aeNRAHZ3Xik55nULmgWMMLPO04ZBmEl8evssvUfMTqdDaFbJgBj2OEfqHt2ygWKhWmCNzqIgu3upuBidKAnbPfn9ChPWVjiAukNt6ftz4eA3ze0CyeSLTiezELX6I/eyiNx3iRhyc9e7cz1WtLWr6rv7anztQ7oej7WjBBwP0f2XJmngKtG6bZTx/JghDx2qTx4ZKSHkQPkaTFzU5/57bXPTjHA6wEnyzIPHvr7S379TZjl4xnuNyJcr0sLG3nFr66i1CerDvQ== nico@desktop"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd8/E/gDl/V+xvQG1yR9TxzHp0MDpGLnSLarb0Vhfp6i2ucX6IrpGWZ6pXyYHPxQzXcIUuDbufoEAFjAc5n8qZ98dbL1TjshnXPU3agQyeJ1zumAcktObqsjLkQV4cG/1OA3v6bDN6s7LX1yfAb156wDQHTj3bVFPdq79gdP2GasMqbm/NOZ9RR01fSSkEa8PqP+2vUkkCNBarQTv3ssMwgbl85wSiHfFYUuXsUXbHDIi1CHRbc4QogBRK5VoGPAk/tOtJ80wLQj2T3o6AEHnKcZOPGJJE4Uy++azyiCFjoy8dU6NMNkIz2yqxXydDefWn81WCLlkOC2ou24t7ZbfcTv63TSl1FLMdV1ME3xqgLDrsE6T6C4eNxVuIEfF3Ff2SVMXErEJGRiJDkHrKED+N1dXNDME7Nft4pAViSWRDURJXZ948YUZWZ9UuxqOg4HzIhdRNnbtjyJeplQMBUDIB73Ux6np254XP1zrxq7ebNVH4Ljo9KzWUNXxSW5iaw0yI/HPTjE4IaVjJwQPBjb+tLpbLxdtQ832QGc74Q7f4vOFVsnLQe18P9nWv5KlyeKh0TowVo04xjQituo/qHijFQ0tmkSBgERqHohbn7/18FTe0tPpY316+FMRlFMHY4x4/KW9D/LeOQtpeXAiixp8QTkAOtX1LhyCV4q6/Q0kYlQ== nico@cachy"
  ];

  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.kernelPackages.kernel.version
  ];
}

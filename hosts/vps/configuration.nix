{
  config,
  inputs,
  lib,
  modulesPath,
  pkgs,
  ...
}:

let
  userName = "nico";
  hostName = "vps";
in

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ./disko.nix
    ./hardware-configuration.nix

    ../../modules/nixos
    ../../modules/homelab
  ];

  # System config
  system = {
    enable = true;
    sops.enable = true;

    inherit userName;
    inherit hostName;

    passwordlessRebuild = true;

    shell = pkgs.zsh;

    udpPorts = [ 24454 ];
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [ pkgs.flite ];

  homelab = {
    enable = true;
    external = true;

    configDir = "/opt/services";
    baseDomain = "nicoladen.dev";

    services = {
      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "mc.nicoladen.dev"
          "mc2.nicoladen.dev"
          "vps.nicoladen.dev"
          "n8n.nicoladen.dev"
          "minio.nicoladen.dev"
        ];
      };

      hytale-server.enable = true;

      minecraft-server =
        let
          servers = import ../../configs/minecraft/servers.nix { inherit pkgs; };
          filteredServers = lib.filterAttrs (_: server: server.host == "vps") servers;
        in
        {
          enable = true;
          servers = lib.mapAttrs (
            name: config:
            removeAttrs config [
              "host"
              "domain"
            ]
          ) filteredServers;
        };

      n8n.enable = true;

      glance.agent = {
        enable = true;
        settings.tokenFile = config.sops.templates."glance/vps_remote_env".path;
      };

      minio.enable = true;

      pyrodactyl.enable = false;
    };
  };

  virtualisation.containers.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = false;
    };
  };

  users.users.nico.extraGroups = [ "docker" ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
      userName = "${config.system.userName}";
    };
    users = {
      "nico" = import ./home.nix;
    };
  };

  nvf.enable = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    targets.nvf.enable = false;
  };

  packages = {
    enable = true;
    terminal.enable = true;
  };

  boot.kernelParams = [ "net.ifnames=0" ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban.enable = true;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaKGBxwribB760V3K59EtWizS0B/1AD5Rx7xeuZD+W5GtlZX955Y8/reQodOoY0uzbXBI3wZYGUi5meHLQWdOn5+WuSCELODbduC86sE6Hmrhfq2Rcr0SU3lmGAOzbsH0DZVd9Qyg9M0oc1DnkYzQgTxkX6mbwQ2iU3e5jBGJwAENqUK8Oq01MlISvNOsIbwUyuh3qkJubYusuWESv4VPDymEWcbDxFPwe5hKT0M5nD31cCAxPSdDmcRGn3Fv+sl9b0aI7yFzQ/FnnS3RG+WXfkVzSENjQ2fycBwHbfmD5Pl8apUnWIM4dfWrxdvVmcqMhEyvhLZpIY31Xyq6hOyx9UbEDiwi79Fyzzhmw+rm8HnxIgLMDVLocDX5R99HirXMEQ2Ybd2N1YbpJzJ13Rhnn47dol5aWprjiRIi/Odap2BwY3SXICt297OwmKegwcWk1zocEARJgPq19GNIuynUEk9opPQaPHvgWMf9RLsiyMnAjGdh+hi7MP4KAP+MWZa80bFe1jz7E+PMpkSoKnB+IrfvqwiApySP9LbIRWVyAXGAr+qPN1H0ztPs6+GbRA+bTXPzudqrdxnw99s7mTMBxKs+Sa4ef5UTpa97FTOWt/MDFhjiFVTuEF3fvm7GEOFEiC3EMBc+/prZfERbRDL0cifEPaGsA8jIW/Eeq9qsbww== nico@desktop"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4UI+xzCxmgUgxZVz9JS1VgYHCUpWEroiAcy8sNpiMdHlS3W74wqpcGtdwQOWbFTTjksB/5OWvhfjblgYMvL45H+SSHS/mwu95UD3tcSP7FAUVUyls2enC6+H8ufLM5onY0nF4pv+t4IosB+ulCjcuNity++ClkGCkGu/D0WSG212I93DY+KgqVhaE4pHmO6Lfo6l8H1DvKEHodh2Nd9VNVd4V3WeczELGFvMnQmcZY86L5xnjQSqbJPX6Cil8oawpbHOSjrNy9Cmn6eC4CJ2kTc5aWA05p09WcJzWSov9lyalYkEbog9Cz1T6ceDesHiyCxh3eHhUrDuS/Gan615To3YUREUsPklwNkifyxHiVEeR7kae10n31X1I8S/q+Wh1XRYjtjDUW1oY0CtX+oThfwikTKMyRxaJJN29lOiaWYZHNVL++w66qGiq2E3jirCg2glu9R1IAEsu7Zqwb8zG5AgrhXwcNVlH0Sp1+KeqF1C+iDrYMj6l7x8qpvamWJlzE0lQwEkLZKdwHSzHPtAyl03i357kZIdeOFSSesJ9SMdBV1K1cUDqCVCma2+s83wuUOA1dFohKnxGnWPa7qKAJ9dSwVYRVYJDZFfrYO8gFJXNKBNcOk9o5SM9qaI7b2SpxYkPn7h/grHty0gVd43Punrv0bx2EjV9xGz871xGIQ== nico@work"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCFTv0zmG+noCzsfKPg0NMTELnweYw4c1gRJ1mGNLwo9R03fHbYJw7zsZ381XWcAWTEa9gysA4LcVhSj9zON0EcD81sbpSAGBSwt61g1nx2X+v3jScRThPAcgrGxdozgcF7tlYDZqy2z5Tm94j/6AswMN/YL2iUxJPiHZcIaZlzVD4Nv8fVTo8SE1poLJBA9xMovYBvVLruyr6yGm2LPu5b3zN3wrQUxrIIxxmzCEtfCsXL3A6gz5OBIoJ5y5/4SE9WveNGdVEcWIcbz4blcTEL4HrZNxrGvBlo+rHxHgd6CbWL/FK92h/rvJKxBU3qMMswr/P3i02Ycl6lS+gwnS8selL0ZAzO47Xz90EAH/5JqSyv8PY/1N6s2LoNCFDOHyX+Sx0SxN7kyoqlH3bbgR2CPpLxixFPnwG8zXxBH0ZywBh4h5EykzuDyb9I5iUYQMPSBRWoKInCjXxPL4fYulckwtB+Rj/neDZEWeUFLG1N3Y+IdInE4GHJYL1dyEz+z9cImQgbcehdIe8WkNppHF3ixksJouWI3qBwYFWVxKAk/s3lP2N2ld8YY2zq70qINfMmMKw4pVIvcCvesGd1m1mEz6kL5TGgPZMjzJ/trAoi/jBbNUoz+eiSstYhL5UHTCwrL272cpBPybAtSSyqyw2lJptePfZCtvXhRfdYoRozQ== nico@server"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd8/E/gDl/V+xvQG1yR9TxzHp0MDpGLnSLarb0Vhfp6i2ucX6IrpGWZ6pXyYHPxQzXcIUuDbufoEAFjAc5n8qZ98dbL1TjshnXPU3agQyeJ1zumAcktObqsjLkQV4cG/1OA3v6bDN6s7LX1yfAb156wDQHTj3bVFPdq79gdP2GasMqbm/NOZ9RR01fSSkEa8PqP+2vUkkCNBarQTv3ssMwgbl85wSiHfFYUuXsUXbHDIi1CHRbc4QogBRK5VoGPAk/tOtJ80wLQj2T3o6AEHnKcZOPGJJE4Uy++azyiCFjoy8dU6NMNkIz2yqxXydDefWn81WCLlkOC2ou24t7ZbfcTv63TSl1FLMdV1ME3xqgLDrsE6T6C4eNxVuIEfF3Ff2SVMXErEJGRiJDkHrKED+N1dXNDME7Nft4pAViSWRDURJXZ948YUZWZ9UuxqOg4HzIhdRNnbtjyJeplQMBUDIB73Ux6np254XP1zrxq7ebNVH4Ljo9KzWUNXxSW5iaw0yI/HPTjE4IaVjJwQPBjb+tLpbLxdtQ832QGc74Q7f4vOFVsnLQe18P9nWv5KlyeKh0TowVo04xjQituo/qHijFQ0tmkSBgERqHohbn7/18FTe0tPpY316+FMRlFMHY4x4/KW9D/LeOQtpeXAiixp8QTkAOtX1LhyCV4q6/Q0kYlQ== nico@cachy"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD8QMloBNFUIap035DELPx20016I/vAaNwzU6ddigFFD2XjLEjqC8tgl+oG+YMl9535vIPa7LybA0J44Tomgztltnh3yLCYAPE8+JRtpDkNZh++lEQSthzrvWcoSsWm5HJliio2bQH37q5lqUptL/muj+BbJ+ONFmkTHh5tJaR4AyArsXaAYIe+iZXXAJY1/TrHfn5hlG4COxyO281cvke7Ac8DoWRMUtr8dl3SJjxyE2NMtHS7Q9yD8PyVknWtieHpb9l56lpMZI9YK5f3K5FT1rMPDikEJVCmJBiMM1Sn9o97Hrr1jrqQP3NYVPP8vkMrB+9aAxBebNHv/r0DtynD nico@ipad"
  ];

  nix.settings.trusted-users = [ "${config.system.userName}" ];

  system.stateVersion = "25.05";

  # Static ip
  networking = {
    defaultGateway = "10.0.0.1";
    nameservers = [
      "8.8.8.8"
    ];
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "10.0.0.68"; # This is the ip address configured in oracle cloud
          prefixLength = 24;
        }
      ];
      # For IPv6
      useDHCP = true;
    };
  };
}

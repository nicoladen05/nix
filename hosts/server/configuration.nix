{
  config,
  lib,
  ...
}:

let
  userName = "nico";
  hostName = "server";
in
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    ../../modules/nixos
    ../../modules/homelab
  ];

  # System configuration
  system = {
    enable = true;
    sops.enable = true;

    # User account
    inherit userName;
    inherit hostName;
    password = {
      enable = true;
      hashedPasswordFile = config.sops.secrets."user/nico/password_hash".path;
    };
    passwordlessRebuild = true;
    ssh.enable = true;
    tcpPorts = [ 22 ];
  };

  # Homelab
  homelab = {
    enable = true;
    external = true;

    baseDomain = "nicoladen.dev";
    internalDomain = "taube.party";

    services = {
      assetto-corsa-server.enable = false;

      backup = {
        enable = true;
        repositoryFile = config.sops.secrets."restic/repository".path;
        passwordFile = config.sops.secrets."restic/password".path;
      };

      code-server.enable = true;

      ddns = {
        enable = true;
        tokenFile = config.sops.secrets."cloudflare/api_token".path;
        domains = [
          "*.nicoladen.dev"
          "ddns.nicoladen.dev"
        ];
      };

      glance.enable = true;

      botify = {
        enable = true;
        tokenFile = config.sops.secrets."services/botify/token".path;
        openaiTokenFile = config.sops.secrets."services/botify/openai_api_key".path;
      };

      immich = {
        enable = true;
        hardwareAcceleration = true;
        mediaLocation = "/data/immich";
      };

      media.jellyfin.enable = true;

      pihole.enable = true;

      paperless.enable = true;

      homeassistant = {
        enable = true;
        expose = true;
      };

      vaultwarden.enable = true;

      spoolman.enable = true;
      spoolman.filabridge.enable = true;

      prusa-octoapp-proxy.enable = true;

      ocis.enable = true;

      openwebui.enable = true;

      wireguard = {
        enable = true;
        externalInterface = "enp1s0";
        ips = [
          "192.168.255.1/32"
          "fd3a:6c4f:1b2e::1/128"
          "2003:e0:17ff:3b42::1/128"
        ];
        privateKeyFile = config.sops.secrets."wireguard/privkey".path;
        peers = {
          # Family
          phone = {
            publicKey = "HUJGJf2uFa8p8EpwQNS5ZKz06qIQOd1uquA8zGkB1Ag=";
            allowedIPs = [
              "192.168.255.2/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          ipad = {
            publicKey = "YRgKxkrWXRrW0Bxpw+w8PCLzPp+2+Luo2TtneZIz+Sc=";
            allowedIPs = [
              "192.168.255.3/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          ipad-luca = {
            publicKey = "83uqVPr2ojPfNDFa0FWy1o6A6qgGJZmeRAR/5rPBVjs=";
            allowedIPs = [
              "192.168.255.4/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          micha = {
            publicKey = "0yiBvElispoc7aktPpL4N7YBmMa3YIPqFq+moR2FUlc=";
            allowedIPs = [
              "192.168.255.5/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };

          # Friends
          jakob = {
            publicKey = "+i9swa1iKylRcFyp8miERswwqRgMsNy1aW7nnxmg9Hc=";
            allowedIPs = [
              "192.168.255.101/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
          olli = {
            publicKey = "HDmDmvKzWQtryIjjVWphF8O/xZRoj5FyGncbE5htIU0=";
            allowedIPs = [
              "192.168.255.102/32"
            ];
            endpoint = "ddns.nicoladen.dev:51820";
          };
        };
      };
    };
  };

  # Static ip
  networking = {
    nameservers = [
      "1.1.1.1"
    ];
    interfaces.enp1s0.ipv4.addresses = [
      {
        address = "192.168.2.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.2.1";
      interface = "enp1s0";
    };
  };

  # Users
  users.users.root.hashedPassword = "$6$FdDJt3LLc3Iu0r14$DKRv42b0IsqkW6OFkWr0WnUoxMPPaFUnSZgBFJKfR4elFeGRU3NfhP1rXbWd.b9073ZucRQrFto130F3eBVjj0";
  users.users.root.hashedPasswordFile = lib.mkForce null;

  users.users.nico.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7TX24VP3LovqziLxEjJsXtL/VCdWNWdhXJgapdmpgXe8qkdPpFA8zybS6E3VB+HfURGKLRutI5kr5FqqDsC/tJe/AmjcZjd9c6Ahq6QoZCv9UJQAb5nhT0aBuV58IoQka0V4MMnPrqA7FnXBZuTX9j3bxydAFsJ3cqHLyhKSL6rRJevkI2tRZXF2ni5TBHFdtWOBpqcWF307am894nc23kn1vKU2i2ZLx+Tc1nIOdfiMLX1+FWUGbSTihXKBmUleYEC2fZpZIMlHcQ6r7S0iovio6wZtLXy00s9q7EkgZ2qOGkHIbk4y6uBBlRyNgMXlS8PmZI7VAZuD0F7DxznmGu6RUrMEoUDlVYe8F90jVZguD2p9vz30za8F+h6R5Q7v2ejvAA0NYFn2Q99PQ5yn+y5avn2qpoM0b8fqpxlf9kNT39wa1lzANvNYG7gaWYI6PAL4EK8TR5EvfKfbN4bHj4nsA9vX/mVGQgoGBgpdyNFSrS5LwG9x3lxBeipJbZcKANccMrFz496XSbUfG9OP3fnljCiG3Ruhl0wQvEYyumgiBjvdfGVdjnHzxDOeUftDdOWRtmQ3VDGjO27g5vlflO+SDgezVAh8f2xd/A/X4vV/LUrFzJzZQFwO9efh2iVe5rf35JwwkdDwo29GiVZhmeASwXzAdji6QHoTuSW1/jQ== nico@win"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaKGBxwribB760V3K59EtWizS0B/1AD5Rx7xeuZD+W5GtlZX955Y8/reQodOoY0uzbXBI3wZYGUi5meHLQWdOn5+WuSCELODbduC86sE6Hmrhfq2Rcr0SU3lmGAOzbsH0DZVd9Qyg9M0oc1DnkYzQgTxkX6mbwQ2iU3e5jBGJwAENqUK8Oq01MlISvNOsIbwUyuh3qkJubYusuWESv4VPDymEWcbDxFPwe5hKT0M5nD31cCAxPSdDmcRGn3Fv+sl9b0aI7yFzQ/FnnS3RG+WXfkVzSENjQ2fycBwHbfmD5Pl8apUnWIM4dfWrxdvVmcqMhEyvhLZpIY31Xyq6hOyx9UbEDiwi79Fyzzhmw+rm8HnxIgLMDVLocDX5R99HirXMEQ2Ybd2N1YbpJzJ13Rhnn47dol5aWprjiRIi/Odap2BwY3SXICt297OwmKegwcWk1zocEARJgPq19GNIuynUEk9opPQaPHvgWMf9RLsiyMnAjGdh+hi7MP4KAP+MWZa80bFe1jz7E+PMpkSoKnB+IrfvqwiApySP9LbIRWVyAXGAr+qPN1H0ztPs6+GbRA+bTXPzudqrdxnw99s7mTMBxKs+Sa4ef5UTpa97FTOWt/MDFhjiFVTuEF3fvm7GEOFEiC3EMBc+/prZfERbRDL0cifEPaGsA8jIW/Eeq9qsbww== nico@work"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDd8/E/gDl/V+xvQG1yR9TxzHp0MDpGLnSLarb0Vhfp6i2ucX6IrpGWZ6pXyYHPxQzXcIUuDbufoEAFjAc5n8qZ98dbL1TjshnXPU3agQyeJ1zumAcktObqsjLkQV4cG/1OA3v6bDN6s7LX1yfAb156wDQHTj3bVFPdq79gdP2GasMqbm/NOZ9RR01fSSkEa8PqP+2vUkkCNBarQTv3ssMwgbl85wSiHfFYUuXsUXbHDIi1CHRbc4QogBRK5VoGPAk/tOtJ80wLQj2T3o6AEHnKcZOPGJJE4Uy++azyiCFjoy8dU6NMNkIz2yqxXydDefWn81WCLlkOC2ou24t7ZbfcTv63TSl1FLMdV1ME3xqgLDrsE6T6C4eNxVuIEfF3Ff2SVMXErEJGRiJDkHrKED+N1dXNDME7Nft4pAViSWRDURJXZ948YUZWZ9UuxqOg4HzIhdRNnbtjyJeplQMBUDIB73Ux6np254XP1zrxq7ebNVH4Ljo9KzWUNXxSW5iaw0yI/HPTjE4IaVjJwQPBjb+tLpbLxdtQ832QGc74Q7f4vOFVsnLQe18P9nWv5KlyeKh0TowVo04xjQituo/qHijFQ0tmkSBgERqHohbn7/18FTe0tPpY316+FMRlFMHY4x4/KW9D/LeOQtpeXAiixp8QTkAOtX1LhyCV4q6/Q0kYlQ== nico@cachy"
  ];
  nix.settings.trusted-users = [ userName ];

  system.stateVersion = "25.05";
}

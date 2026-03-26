{ lib, config, pkgs, ... }:

let
  cfg = config.homelab.services.spoolman;
in
{
  imports = [
    ./filabridge.nix
  ];

  options.homelab.services.spoolman = {
    enable = lib.mkEnableOption "spoolman";
    port = lib.mkOption {
      type = lib.types.int;
      default = 7912;
      description = "The port on which spoolman will listen.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev:
        let
          python = prev.python312;
          hishel = python.pkgs.buildPythonPackage rec {
            pname = "hishel";
            version = "0.1.2";
            pyproject = true;

            src = prev.fetchPypi {
              inherit pname version;
              hash = "sha256-ZkNFC/sc+i7NYAJ2n29QadDQSMnB8eKamKSDAtWHUJI=";
            };

            build-system = with python.pkgs; [ hatch-fancy-pypi-readme hatchling ];

            dependencies = with python.pkgs; [
              anyio
              httpcore
              httpx
              msgpack
            ];

            pythonImportsCheck = [ "hishel" ];
          };
        in
        {
          spoolman = prev.spoolman.overridePythonAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ python.pkgs.pythonRelaxDepsHook ];

            propagatedBuildInputs = builtins.map (
              dep:
              if lib.hasAttrByPath [ "pname" ] dep && dep.pname == "hishel" then hishel else dep
            ) (old.propagatedBuildInputs or [ ]);

            pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [
              "hishel"
              "websockets"
            ];
          });
        })
    ];

    services.spoolman = {
      enable = true;
      listen = "0.0.0.0";
      inherit (cfg) port;
      openFirewall = true;
    };
    services.caddy.virtualHosts = {
      "spoolman.${config.homelab.internalDomain}" = {
        extraConfig = ''
          import cloudflare_dns
          reverse_proxy 127.0.0.1:${builtins.toString cfg.port}
        '';
      };
    };
  };
}

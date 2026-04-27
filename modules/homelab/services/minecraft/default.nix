{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options = {
    homelab.services.minecraft-server = {
      enable = lib.mkEnableOption "enable the minecraft server";

      servers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              port = lib.mkOption {
                type = lib.types.int;
                default = 25565;
                example = 25565;
                description = ''
                  The port on which the Minecraft server will listen.
                '';
              };

              type = lib.mkOption {
                type = lib.types.enum [
                  "vanilla"
                  "fabric"
                  "forge"
                  "neoforge"
                  "quilt"
                  "paper"
                ];
                default = "vanilla";
                example = "fabric";
                description = ''
                  The type of Minecraft server to run.
                  - `vanilla`: The official Minecraft server.
                  - `fabric`: A lightweight modding toolchain.
                  - `forge`: A popular modding platform.
                  - `neoforge`: A modern fork of Forge.
                  - `quilt`: A modern modding platform that is a continuation of Fabric.
                  - `paper`: A high-performance fork of Spigot.
                '';
              };

              version = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "1.21.7";
                description = ''
                  The version of the Minecraft server to run.
                  If not specified, the latest version will be used.
                '';
                apply =
                  v:
                  if v == "" then
                    ""
                  else
                    let
                      parts = builtins.splitVersion v;
                    in
                    if builtins.length parts < 3 then
                      throw "Version must be in the format X.Y.Z"
                    else
                      # Transform version string (e.g. "1.21.7") into format -X_XX_X (e.g. "-1_21_7")
                      "-" + builtins.concatStringsSep "_" parts;
              };

              ram = lib.mkOption {
                type = lib.types.str;
                default = "4G";
                example = "2G";
                description = ''
                  The amount of RAM to allocate to the Minecraft server.
                  This should be a string with a number followed by a unit (e.g. "2G" for 2 gigabytes).
                '';
              };

              properties = lib.mkOption {
                type = lib.types.attrs;
                default = { };
                description = ''
                  Additional properties to pass to the Minecraft server.
                  These should be key-value pairs.
                '';
              };

              whitelist = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = ''
                  A whitelist of players allowed to join the server.
                  The keys are player names, and the values are their UUIDs.
                '';
              };

              mods = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Enable custom mods for this server.";
                    };
                    mods = lib.mkOption {
                      type = lib.types.attrsOf lib.types.package;
                      default = { };
                    };
                    modpack = lib.mkOption {
                      type = lib.types.package;
                      default = null;
                    }
                  };
                };
                default = { };
              };

              packwiz = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Enable packwiz support for this server.";
                    };
                    url = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "The URL to the packwiz modpack.";
                    };
                    packHash = lib.mkOption {
                      type = lib.types.str;
                      default = "";
                      description = "The expected hash of the modpack for verification.";
                    };
                  };
                };
                default = { };
                description = "Options for packwiz modpack support.";
              };
            };
          }
        );
      };
    };
  };

  config = lib.mkIf config.homelab.services.minecraft-server.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = lib.mapAttrs (
        serverName: serverConfig:
        let
          # compute attribute name for package lookup, e.g. "fabric-1_21_7"
          attrName = "${serverConfig.type}${serverConfig.version}";
          package = builtins.getAttr attrName pkgs.minecraftServers;
          modpack =
            if (serverConfig.packwiz != null) && serverConfig.packwiz.enable then
              pkgs.fetchPackwizModpack {
                inherit (serverConfig.packwiz) url packHash;
              }
            else
              null;
        in
        {
          enable = true;
          jvmOpts = "-Xmx${serverConfig.ram} -Xms${serverConfig.ram}";
          inherit package;
          inherit (serverConfig) whitelist;

          serverProperties = serverConfig.properties // {
            server-port = serverConfig.port;
            white-list = if serverConfig.whitelist == { } then false else true;
          };

          # only add symlinks when packwiz is enabled
          symlinks =
            lib.optionalAttrs ((serverConfig.packwiz != null) && serverConfig.packwiz.enable) {
              mods = "${modpack}/mods";
            }
            // lib.optionalAttrs (serverConfig.mods.enable) (
              lib.mapAttrs' (name: mod: {
                name = "mods/${name}.jar";
                value = mod;
              }) serverConfig.mods.mods
            ) // lib.optionalAttrs (serverConfig.modpack != null) {
              mods = "${serverConfig.modpack}/mods";
              config = "${serverConfig.modpack}/config";
            };
        }
      ) config.homelab.services.minecraft-server.servers;
    };
  };
}

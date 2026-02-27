# hytale-server.nix

A Nix flake to package and run a Hytale dedicated server on NixOS.

## Requirements
- A valid Hytale account to download the server
- At least 4GB of RAM (as per the official server documentation)

## Usage

### Running the Hytale server on NixOS

You can use this flake as an input in your own NixOS configuration to run the Hytale server.

1.  Add this flake to your inputs in `/etc/nixos/flake.nix`:

    ```nix
    {
      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        hytale-server.url = "github:nicoladen05/hytale-server-nix"; # Add this
        hytale-server.inputs.nixpkgs.follows = "nixpkgs"; # Add this
      };

      outputs = { self, nixpkgs, ... }@inputs: {
        nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            inputs.hytale-server.nixosModules # Add this
          ];
        };
      };
    }
    ```

2.  Enable and configure the server in your `/etc/nixos/configuration.nix`:

    ```nix
    {
      services.hytale-server = {
        enable = true;
        assets = /var/lib/hytale-server/assets.zip; # This file needs to be downloaded manually. See below.
        openFirewall = true;
        jvmOptions = [ "-Xmx4G" "-Xms4G" ];
        # See below for all available options
      };
    }
    ```

3.  Rebuild your system:

    ```sh
    sudo nixos-rebuild switch
    ```
    (this command will fail, read below)

### Manual Download

The Hytale server requires manual download with a valid Hytale account. When you build the server package for the first time, Nix will stop and provide instructions on how to download the `HytaleServer.jar` file and add it to the Nix store.

Please follow the on-screen instructions.

You also need to provide the server with the path to the assets file, which you also get with the server. Set the `services.hytale-server.assets` option to the path of this file.

### Managing the server
The server runs in a tmux-session inside a systemd service (`hytale-server`). You can manage it using normal systemd commands. The module also provides a command to attach to the tmux server console: 

```bash
hytale-console
```

## Module Options

The following options are available for the `services.hytale-server` module:

| Option               | Type                | Default                                       | Description                                                                                             |
| -------------------- | ------------------- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| `enable`             | boolean             | `false`                                       | Enable the Hytale server.                                                                               |
| `package`            | package             | `pkgs.hytale-server`                          | The Hytale server package to use.                                                                       |
| `javaPackage`        | package             | `pkgs.jdk`                                    | The Java package to use for running the server.                                                         |
| `jvmOptions`         | list of strings     | `[]`                                          | Extra JVM options to pass to the Hytale server.                                                         |
| `acceptEarlyPlugins` | boolean             | `false`                                       | Acknowledge that loading early plugins is unsupported and may cause stability issues.                   |
| `authMode`           | enum                | `"authenticated"`                             | Authentication mode (`authenticated`, `offline`, `insecure`).                                           |
| `serverPort`         | port                | `5520`                                        | The UDP port for the Hytale server to listen on.                                                        |
| `openFirewall`       | boolean             | `false`                                       | Whether to open the server port in the firewall.                                                        |
| `backup.enable`      | boolean             | `false`                                       | Enable backups.                                                                                         |
| `backup.path`        | path                | `"/var/lib/hytale-server/backup"`             | Path to the backup directory.                                                                           |
| `backup.frequency`   | integer             | `30`                                          | Frequency of backups in minutes.                                                                        |
| `backup.maxCount`    | integer             | `5`                                           | Maximum number of backups to keep.                                                                      |
| `universe`           | path                | `"/var/lib/hytale-server/universe/worlds/default"` | Path to the universe directory.                                                                           |
| `assets`             | path                | *required*                                    | Path to the assets directory. This is required to run the server.                                       |
| `dataDir`            | path                | `"/var/lib/hytale-server"`                    | Directory to store Hytale server data.                                                                  |
| `user`               | string              | `"hytale-server"`                             | User account under which the server runs.                                                               |
| `group`              | string              | `"hytale-server"`                             | Group under which the server runs.                                                                      |

## Troubleshooting
### Server Won't Start
Check the logs for errors:
```bash
sudo journalctl -u hytale-server -n 50
```

#### Common issues:
- Hash mismatch: The server JAR hash doesn't match - submit an issue or a PR. You can use an override to update the hash of the server package to the correct version.

### File Locations
- Server data: /var/lib/hytale-server/
- World data: /var/lib/hytale-server/universe/worlds/default/
- Backups: /var/lib/hytale-server/backups/ (if enabled)
- Logs: View with journalctl -u hytale-server
- Console socket: /var/lib/hytale-server/hytale.sock

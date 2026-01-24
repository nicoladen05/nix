# NixOS Configuration Repository

This repository contains NixOS system configurations for multiple hosts.

## Quick Reference

**Package Manager**: `nix`
**Build (does not deploy, use for testing changes)**:
```bash
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
```

**Deploy (only run this when explicitly requested)**:
```bash
nix develop -c deploy .#<host>
```

**Check**:
```bash
nix flake check
```

## Module Structure Pattern
```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.homelab;
in
{
  options.homelab = {
    enable = mkEnableOption "enable homelab configuration";

    baseDomain = mkOption {
      type = types.str;
      example = "example.com";
      description = "Base domain for homelab services";
    };
  };

  config = mkIf cfg.enable {
    # Configuration here
  };
}
```

# Development Guidelines

## Adding New Services
1. Create module in `modules/homelab/`, `modules/nixos/`, or `modules/home-manager/` as appropriate
2. Import the module in the host configuration and enable it
3. Include proper options and validation
4. Test with `nix build .#nixosConfigurations.<host>.config.system.build.toplevel` before switching

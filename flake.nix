{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko.url = "github:nix-community/disko";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";

    deploy-rs.url = "github:serokell/deploy-rs";

    stylix.url = "github:danth/stylix";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf/";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    prusa-octoapp-proxy = {
      url = "github:nicoladen05/prusa-octoapp-proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flux = {
      url = "github:IogaMaster/flux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-server-nix = {
      url = "github:nicoladen05/hytale-server-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    botify = {
      url = "github:nicoladen05/botify";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    danksearch = {
      url = "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      network = import ./configs/network;
    in
    {
      # NixOS Configurations
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/desktop/configuration.nix
          impermanence.nixosModules.impermanence
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nvf.nixosModules.default
        ];
      };

      nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/vps/configuration.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nvf.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
          prusa-octoapp-proxy.nixosModules.default
        ];
      };

      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs network; };
        modules = with inputs; [
          ./hosts/server/configuration.nix
          disko.nixosModules.disko
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix
          nvf.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
          prusa-octoapp-proxy.nixosModules.default
        ];
      };

      # HomeManager Configurations
      homeConfigurations.nico = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        extraSpecialArgs = {
          inherit inputs;
          userName = "nico";
        };
        modules = with inputs; [
          ./home/nico.nix
          stylix.homeModules.stylix
          nvf.homeManagerModules.default
        ];
      };

      # Packages
      packages."x86_64-linux".pycord = pkgs.callPackage ./packages/pycord.nix { };
      packages."x86_64-linux".wavelink = pkgs.callPackage ./packages/wavelink.nix { };
      packages."x86_64-linux".t3-code = pkgs.callPackage ./packages/t3-code.nix { };

      # Dev Shells
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        packages = [
          inputs.deploy-rs.packages.x86_64-linux.deploy-rs
          pkgs.nil
          pkgs.nixd
          pkgs.nixfmt
        ];
      };

      devShells.aarch64-linux.default = nixpkgs.legacyPackages.aarch64-linux.mkShell {
        packages = [
          inputs.deploy-rs.packages.aarch64-linux.deploy-rs
          pkgs.nil
          pkgs.nixd
          pkgs.nixfmt
        ];
      };

      # DeployRS Nodes
      deploy.nodes.vps = {
        hostname = "130.61.231.173";
        remoteBuild = true;
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.vps;
        };
      };

      deploy.nodes.server = {
        hostname = network.clients.server.ip;
        interactiveSudo = true;
        profiles.system = {
          user = "root";
          sshUser = "nico";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.server;
        };
      };
    };
}

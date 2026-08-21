{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      disko,
      nixos-hardware,
      home-manager,
      microvm,
      ...
    }:
    let
      packageOverlay =
        final: prev:
        let
          system = final.stdenv.hostPlatform.system;
        in
        {
          unstable = import nixpkgs-unstable {
            inherit system;
            config = prev.config;
          };

          unofficial = inputs.llm-agents.packages.${system} // import ./pkgs { pkgs = final; };
        };

      baseModules = [
        ./base
        {
          nixpkgs.overlays = [ packageOverlay ];
        }
      ];

      mkHost =
        {
          host,
          system,
          extraModules ? [ ],
        }:
        let
          platform = nixpkgs.lib.systems.elaborate system;
          builder = if platform.isDarwin then darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
          systemModules =
            if platform.isDarwin then
              [
                home-manager.darwinModules.home-manager
              ]
            else
              [
                disko.nixosModules.disko
                home-manager.nixosModules.home-manager
              ];
        in
        builder {
          inherit system;
          specialArgs = {
            inherit platform;
          };
          modules =
            baseModules
            ++ systemModules
            ++ extraModules
            ++ [
              {
                networking.hostName = host;
              }
              ./hosts/${host}.nix
            ];
        };
    in
    {
      nixosConfigurations = {
        ryzentower = mkHost {
          host = "ryzentower";
          system = "x86_64-linux";
        };
        thinkpadz13 = mkHost {
          host = "thinkpadz13";
          system = "x86_64-linux";
          extraModules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-z13-gen1
          ];
        };
        codeserver = mkHost {
          host = "codeserver";
          system = "x86_64-linux";
        };
        codeserver-microvm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit nixpkgs;
            platform = nixpkgs.lib.systems.elaborate "aarch64-linux";
          };
          modules = [
            home-manager.nixosModules.home-manager
            microvm.nixosModules.microvm
            {
              options.primaryUser = {
                username = nixpkgs.lib.mkOption {
                  type = nixpkgs.lib.types.str;
                  description = "Local account username for this host.";
                };
                authorizedKeys = nixpkgs.lib.mkOption {
                  type = nixpkgs.lib.types.listOf nixpkgs.lib.types.str;
                  default = [ ];
                  description = "SSH public keys authorized for the primary user on this host.";
                };
              };

              config.nixpkgs.overlays = [ packageOverlay ];
            }
            ./hosts/codeserver-vm.nix
          ];
        };
      };

      darwinConfigurations = {
        "MacBookPro" = mkHost {
          host = "MacBookPro";
          system = "aarch64-darwin";
        };
        "AS-GXL19NXYYQ" = mkHost {
          host = "AS-GXL19NXYYQ";
          system = "aarch64-darwin";
        };
        macos-test = mkHost {
          host = "macos-test";
          system = "aarch64-darwin";
        };
      };
    };
}

{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon/release-2025-11-18"; # TODO use 26.05
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixos-apple-silicon,
      darwin,
      disko,
      nixos-hardware,
      home-manager,
      ...
    }:
    let
      baseModules = [
        ./base
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = import nixpkgs-unstable {
                inherit (prev.stdenv.hostPlatform) system;
                config = prev.config;
              };
            })
          ];
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
        MacBookTux = mkHost {
          host = "MacBookTux";
          system = "aarch64-linux";
          extraModules = [
            nixos-apple-silicon.nixosModules.apple-silicon-support
            (
              { lib, ... }:
              {
                hardware.asahi.pkgs = lib.mkForce (
                  import nixpkgs {
                    system = "aarch64-linux";
                    overlays = [
                      nixos-apple-silicon.overlays.default
                    ];
                  }
                );
              }
            )
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

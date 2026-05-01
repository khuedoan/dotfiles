{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
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

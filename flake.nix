{
  description = "Gleb's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in {
      overlays = import ./overlays {inherit inputs;};
      nixosConfigurations = {
        "gnpc" = lib.nixosSystem {
          system = system;
          modules = [
            ./configuration.nix
            agenix.nixosModules.default
          ];
          specialArgs = { inherit inputs; };
        };
      };
      homeConfigurations =  {
        "gleb" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };
}

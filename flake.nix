{
  description = "Gleb's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # Build baseline pkgs for Home Manager using the new overlay attribute
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ outputs.overlays.unstable-packages ];
        config.allowUnfree = true;
      };
    in {
      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {
        "gnpc" = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./configuration.nix
            agenix.nixosModules.default

            # Inject the overlay into the NixOS module system
            { nixpkgs.overlays = [ outputs.overlays.unstable-packages ]; }
          ];
        };
      };

      homeConfigurations =  {
        "gleb" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs; # Inherits the overlay seamlessly
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home.nix ];
        };
      };
    };
}

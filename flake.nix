{
  description = "Claud's setup";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    inherit (nixpkgs.lib) nixosSystem;
  in {
    nixosConfigurations = {
      nixos = nixosSystem {
        system = "x86_64-linux";  # Specify the system architecture
        modules = [ ./nixos/configuration.nix ];
      };
    };

    homeConfigurations = {
      "claud@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager/home.nix ];
      };
    };
  };
}

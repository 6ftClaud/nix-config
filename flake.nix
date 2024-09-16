{
  description = "Claud's setup";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Catppuccin
    catppuccin.url = "github:catppuccin/nix";

    # Pre-commit hooks
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , catppuccin
    , ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      inherit (nixpkgs.lib) nixosSystem;
    in
    {
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = { };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });

      nixosConfigurations = {
        nixos = nixosSystem {
          system = "x86_64-linux"; # Specify the system architecture
          modules = [
            ./nixos/configuration.nix
            catppuccin.nixosModules.catppuccin
          ];
        };
      };

      homeConfigurations = {
        "claud@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home-manager/home.nix
            catppuccin.homeManagerModules.catppuccin
          ];
        };
      };
    };
}

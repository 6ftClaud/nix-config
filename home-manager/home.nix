#home-manager/home.nix
{ inputs
, lib
, config
, pkgs
, ...
}:
{

  imports = [
    ./dotfiles.nix # Dotfiles configuration
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "claud";
    homeDirectory = "/home/claud";
    packages = with pkgs; [
      discord
      docker-compose
      flatpak
      gnomeExtensions.pop-shell
      nixfmt-rfc-style # Nix formatting tool
      pre-commit
      runelite
      signal-desktop
      steam
      tela-icon-theme # Icon Theme
      tidal-hifi
      vlc
      volantes-cursors # Cursor Theme
      vscode
    ];
  };

  # Configure GTK theming
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
      size = "standard";
      tweaks = [ "normal" ];
    };
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

#nixos/packages/gnome.nix

{ pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Exclude specific GNOME packages
  environment.gnome.excludePackages =
    (with pkgs; [
      # gnome-photos
      gnome-tour
      gnome-text-editor
    ])
    ++ (with pkgs.gnome; [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      # gnome-calculator
      gnome-characters
      gnome-contacts
      gnome-maps
      gnome-music
      gnome-terminal
      # gnome-weather
      hitori # sudoku game
      iagno # go game
      simple-scan
      tali # poker game
      totem # video player
      yelp # help viewer
    ]);

  # Install other system packages
  environment.systemPackages = (with pkgs; [ gnome.gnome-tweaks ]);

  # Enable dconf for GNOME settings
  programs.dconf.enable = true;
}

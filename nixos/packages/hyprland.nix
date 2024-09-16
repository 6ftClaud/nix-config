#nixos/packages/hyprland.nix
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dunst # Notification Daemon
    rofi-wayland # Menu
    waybar # Status Bar
  ];

  programs = {
    hyprland.enable = true; # Window Manager
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # hint Electron apps to use Wayland

}

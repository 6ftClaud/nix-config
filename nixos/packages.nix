#nixos/hardware-configuration.nix
{ pkgs, config, ... }:

{
  imports = [
    packages/gnome.nix # Gnome DE
    packages/hyprland.nix # Hyprland WM
  ];

  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    google-chrome
    kitty
    nano
    ncdu
    neofetch
    roboto # font
    tree
    vim
    wget
    wireguard-go
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "ls -lh --group-directories-first --color=always";
      ncdu = "ncdu --color off";
      d = "docker";
      dc = "docker-compose";
      k = "kubectl";
    };

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
      ];
      custom = "${config.users.users.claud.home}/.local/share/oh-my-zsh";
      theme = "claud";
    };

  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  virtualisation.docker.enable = true;
}

#nixos/configuration.nix
{ config
, pkgs
, lib
, ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan
    ./packages.nix # System packages
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Need this for docker wireguard https://github.com/NixOS/nixpkgs/issues/179741#issuecomment-1188796132
  networking.nftables.enable = false;
  networking.firewall.package = pkgs.iptables-legacy;

  # Set your time zone.
  time.timeZone = "Europe/Vilnius";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in the config for now)
    #media-session.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  users.users = {
    claud = {
      # Change via `passwd` after first boot
      description = "Claud";
      initialPassword = "nixos123";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      useDefaultShell = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

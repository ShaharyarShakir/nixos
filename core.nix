{ config, pkgs, ... }:

{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Host
  networking.hostName = "nixos";

  # Local Omni lab names
  networking.hosts = {
    "10.221.146.1" = [
      "omni.internal"
      "auth.internal"
    ];
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;
  # Locale / timezone
  time.timeZone = "Asia/Karachi";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.shaharyar = {
    isNormalUser = true;
    description = "shaharyar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "incus-admin"
      "docker"
    ];
  };
  users.users.shaharyar.shell = pkgs.zsh;
  services.udisks2.enable = true;
  programs.zsh.enable = true;

  # nix experiment
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "shaharyar"
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  # Allow unfree packages

  services.upower.enable = true;
  nixpkgs.config.allowUnfree = true;
  networking.firewall.enable = false;

  # NixOS version this configuration was originally created against.
  system.stateVersion = "26.05";
}

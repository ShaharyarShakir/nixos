{ config, pkgs, ... }:

{
  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Host
  networking.hostName = "nixos";

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

   programs.zsh.enable = true;
   nix.settings.experimental-features = [
  "nix-command"
  "flakes"
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # NixOS version this configuration was originally created against.
  system.stateVersion = "26.05";
}

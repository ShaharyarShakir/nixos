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
    LC_ADDRESS = "ur_PK";
    LC_IDENTIFICATION = "ur_PK";
    LC_MEASUREMENT = "ur_PK";
    LC_MONETARY = "ur_PK";
    LC_NAME = "ur_PK";
    LC_NUMERIC = "ur_PK";
    LC_PAPER = "ur_PK";
    LC_TELEPHONE = "ur_PK";
    LC_TIME = "ur_PK";
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
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # NixOS version this configuration was originally created against.
  system.stateVersion = "26.05";
}

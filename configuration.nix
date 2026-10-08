{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./core.nix
    ./desktop.nix
    ./programs.nix
    ./containers.nix
    ./development.nix
  ];
}

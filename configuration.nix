{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./core.nix
    ./desktop.nix
    ./programs.nix
    ./containers.nix
    ./development.nix
    ./virtualization.nix
    ./nix-ld.nix
    # Legacy FireCrab service file left intact but not imported here.
    # ./services/firecrab.nix
  ];
}

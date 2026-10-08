{ config, pkgs, ... }:

{
  imports = [
    ./shell/zsh.nix
  ];

  home.username = "shaharyar";
  home.homeDirectory = "/home/shaharyar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Keep your other existing configuration here.
}

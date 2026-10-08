{ config, pkgs, ... }:

{
  home.username = "shaharyar";
  home.homeDirectory = "/home/shaharyar";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "eza -lah";
      la = "eza -a";
      l = "eza -lah";
      ".." = "cd ..";
    };
  };
}

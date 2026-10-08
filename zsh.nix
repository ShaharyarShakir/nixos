{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;

      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ".." = "cd ..";
      l = "eza -lah";
      la = "eza -a";
      ll = "eza -lah";
      vi = "nvim";
      v = "nvim";
      c = "clear";
      y = "yazi";
      lg = "lazygit";
    };
  };
}

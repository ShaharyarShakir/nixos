{ config, pkgs, ... }:

{
  imports = [
    ./shell/zsh.nix
    ./editor/emacs.nix
    ./editor/nvim.nix
../modules/cubic.nix
  ];

  home.username = "shaharyar";
  home.homeDirectory = "/home/shaharyar";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Shaharyar Shakir";
        email = "shakirshaharyar125@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep
    fzf
    lazygit
    yazi
    tree
    jq
    curl
    wget
    unzip
    zip
    rsync
    zoxide
  ];
}

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

  programs.git = {
  enable = true;

  userName = "Shaharyar Shakir";
  userEmail = "shakirshaharyar125@gmail.com";

  extraConfig = {
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
];

}

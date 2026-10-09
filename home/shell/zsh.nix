{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    programs.zsh.enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

 plugins = [
    {
      name = "zsh-completions";
      package = pkgs.zsh-completions;
    }

    {
      name = "fzf-tab";
      package = pkgs.zsh-fzf-tab;
    }
  ];

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

  gs = "git status";
  ga = "git add";
  gc = "git commit";
  gp = "git push";
  gl = "git pull";
  gd = "git diff";
  gco = "git checkout";
  gb = "git branch";
};


initContent = ''
  bindkey -e
  bindkey '^p' history-search-backward
  bindkey '^n' history-search-forward

  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
  zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"  
  zstyle ':completion:*' menu no

  zstyle ':fzf-tab:completion:cd:*' fzf-preview 'ls --color $realpath'
  zstyle ':fzf-tab:completion:__zoxide_z:*' fzf-preview 'ls --color $realpath'

  if [[ -o interactive && ! -f "/tmp/fastfetch_ran_$USER" ]]; then
    fastfetch

    print_logo() {
      cat << "EOF"
██████╗ ███████╗██╗   ██╗ ██████╗██████╗  █████╗ ███████╗████████╗
██╔══██╗██╔════╝██║   ██║██╔════╝╚══██╔╝██╔══██╗██╔════╝╚══██╔══╝
██║  ██║█████╗  ██║   ██║██║      █████╔╝ ███████║█████╗     ██║
██║  ██║██╔══╝  ╚██╗ ██╔╝██║     ██╔══██╗ ██╔══██║██╔══╝     ██║
██████╔╝███████╗ ╚████╔╝ ╚██████╗██║  ██║ ██║  ██║██║        ██║
╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝╚═╝  ╚═╝ ╚═╝  ╚═╝╚═╝        ╚═╝
EOF
    }

    print_logo
    touch "/tmp/fastfetch_ran_$USER"
  fi
'';
  };
}

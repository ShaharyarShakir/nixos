{ config, pkgs, lib, ... }:

let
  home = config.home.homeDirectory;

  # Logo lives in the store so we don't need a heredoc inside the Nix string
  logo = pkgs.writeText "devcraft-logo.txt" ''
    ██████╗ ███████╗██╗   ██╗ ██████╗██████╗  █████╗ ███████╗████████╗
    ██╔══██╗██╔════╝██║   ██║██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
    ██║  ██║█████╗  ██║   ██║██║     ██████╔╝███████║█████╗     ██║
    ██║  ██║██╔══╝  ╚██╗ ██╔╝██║     ██╔══██╗██╔══██║██╔══╝     ██║
    ██████╔╝███████╗ ╚████╔╝ ╚██████╗██║  ██║██║  ██║██║        ██║
    ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝
  '';
in
{
  # ---------------------------------------------------------------------------
  # Packages the old .zshrc assumed were installed
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    eza
    fastfetch
    ripgrep
    lazygit
    yazi
    fnm
    zsh-completions # picked up through ~/.nix-profile/share/zsh/site-functions
  ];

  # ---------------------------------------------------------------------------
  # Tools that were `eval "$(x init zsh)"` in .zshrc -> native HM modules
  # ---------------------------------------------------------------------------
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # replaces eval "$(fzf --zsh)" + OMZP::fzf
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ]; # replaces eval "$(zoxide init --cmd cd zsh)"
  };

  programs.starship.enable = true; # replaces eval "$(starship init zsh)"
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship_zsh.toml);
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # replaces eval "$(direnv hook zsh)"
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true; # replaces eval "$(mise activate zsh)"
  };

  # ---------------------------------------------------------------------------
  # Environment variables / PATH (were `export ...` lines)
  # ---------------------------------------------------------------------------
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    YAZI_EDITOR = "nvim";

    _ZO_ECHO = "1";

    BUILDKIT_HOST = "unix:///run/user/1000/buildkit/buildkitd.sock";

    ANDROID_HOME = "${home}/Android";
    ANDROID_SDK_ROOT = "${home}/Android";

    PURO_ROOT = "${home}/.puro";

    ZEPHYR_TOOLCHAIN_HOME = "${home}/Downloads/zephyr-sdk-0.17.0";
    ZEPHYR_SDK_INSTALL_DIR = "${home}/zephyr-sdk-0.17.0";
  };

  home.sessionPath = [
    "${home}/.local/bin"
    "${home}/.rvm/bin"
    "${home}/.rd/bin" # Rancher Desktop
    "${home}/.cache/.bun/bin"
    "${home}/.local/share/solana/install/active_release/bin"

    # Android SDK
    "${home}/Android/platform-tools"
    "${home}/Android/emulator"
    "${home}/Android/cmdline-tools/latest/bin"

    # Puro (Flutter)
    "${home}/.puro/bin"
    "${home}/.puro/shared/pub_cache/bin"
    "${home}/.puro/envs/default/flutter/bin"
  ];

  # ---------------------------------------------------------------------------
  # Zsh itself
  # ---------------------------------------------------------------------------
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true; # zsh-autosuggestions
    syntaxHighlighting.enable = true; # zsh-syntax-highlighting

    history = {
      size = 5000;
      save = 5000;
      path = "${home}/.zsh_history";

      share = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      findNoDups = true;
    };

    # zinit plugins that aren't OMZ snippets
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    # zinit snippet OMZP::* -> oh-my-zsh plugins
    # Dropped on purpose (see notes): command-not-found, nvm, z, themes, fzf
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "kubectl"
        "aws"
        "terraform"
        "kubectx"
        "npm"
        "node"
        "aliases"
        "common-aliases"
        "extract"
        "colored-man-pages"
        "history"
        "sudo"
        "gcloud"
        "python"
        "pip"
        "virtualenv"
        "rails"
        "composer"
      ];
    };

    shellAliases = {
      # ls / eza
      ls = "eza --icons -lah --group-directories-first --git";
      lss = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
      lt = "eza -T --icons";
      ll = "eza -lh --icons";
      la = "eza -la --icons";
      l = "eza -l --icons --git";
      lsize = "eza -lh --icons -s size -r";
      lmod = "eza -lh --icons -s modified";
      cmatrix = "cmatrix -u 10 -B -f";

      # editors / tools (alias y is a function below, lg = lazygit won in the old file)
      vi = "nvim";
      v = "nvim";
      c = "clear";
      cls = "clear";
      lg = "lazygit";
      grep = "rg";

      # directory navigation
      he = "cd ~";
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      bd = ''cd "$OLDPWD"'';

      # kubectl
      k = "kubectl";
      kx = "kubectl exec -it";
      kg = "kubectl get";

      # github cli
      gh-create = "gh repo create --private --source=. --remote=origin && git push -u --all && gh browse";
      gh-issue = "gh issue create --web";
      gh-pr = "gh pr create --web";

      # taskfile
      t = "task";
      tl = "task --list-all";
    };

    initContent = lib.mkMerge [
      # ---- runs first (like the old top-of-file fastfetch block) -------------
      (lib.mkBefore ''
        FLAG_FILE="/tmp/fastfetch_ran_$USER"
        trap "\rm -f '$FLAG_FILE'" EXIT

        if [[ -o interactive && ! -f "$FLAG_FILE" ]]; then
          fastfetch
          cat ${logo}
          touch "$FLAG_FILE"
        fi
      '')

      # ---- everything else ---------------------------------------------------
      ''
        # keybinds
        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        # extra history options
        HISTDUP=erase
        setopt append_history

        # completion style
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:completion:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:completion:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        # Taskfile completion
        if command -v task >/dev/null 2>&1; then
          eval "$(task --completion zsh)"
        fi

        # Devbox completion
        if command -v devbox >/dev/null 2>&1; then
          eval "$(devbox completion zsh)"
        fi

        # Angular CLI completion
        if command -v ng >/dev/null 2>&1; then
          source <(ng completion script)
        fi

        # bun completions
        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

        # fnm
        if command -v fnm >/dev/null 2>&1; then
          eval "$(fnm env --use-on-cd)"
        fi

        # JAVA_HOME via mise
        if command -v mise >/dev/null 2>&1; then
          export JAVA_HOME="$(mise where java 2>/dev/null)"
        fi

        # ssh-agent socket (needs XDG_RUNTIME_DIR, so set at shell start)
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

        # secrets: keep out of the Nix store, read from a private file instead
        [[ -r "$HOME/.secrets/omniroute_api_key" ]] && \
          export OMNIROUTE_API_KEY="$(<"$HOME/.secrets/omniroute_api_key")"

        # wt shell integration
        if command -v wt >/dev/null 2>&1; then
          eval "$(command wt config shell init zsh)"
        fi

        # conda / micromamba (only if present; these don't come from Nix)
        if [[ -x "$HOME/miniconda3/bin/conda" ]]; then
          eval "$("$HOME/miniconda3/bin/conda" shell.zsh hook 2>/dev/null)"
        fi
        export MAMBA_ROOT_PREFIX="$HOME/.local/share/mamba"
        export MAMBA_EXE="$HOME/01__git-repos/Coding-Practice/.pixi/envs/default/bin/micromamba"
        if [[ -x "$MAMBA_EXE" ]]; then
          eval "$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
        fi

        # --- auto `ls` after cd -------------------------------------------------
        __last_dir="$PWD"
        __auto_ls_on_cd() {
          if [[ "$PWD" != "$__last_dir" ]]; then
            __last_dir="$PWD"
            echo -e "\n📂 $(pwd)"
            ls --color=auto -lah
          fi
        }
        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd __auto_ls_on_cd

        # --- functions ------------------------------------------------------------
        # mkdir + cd
        mkdirg() {
          mkdir -p "$1" && cd "$1"
        }

        # yazi: cd to last directory on exit
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d ''' cwd < "$tmp"
          [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }
      ''
    ];
  };
}

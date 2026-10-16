{ pkgs, inputs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    pluginSource = "nixpkgs";   
    configFiles = ./lazyvim;

    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      # JS / TS
      javascript typescript tsx jsdoc json jsonc html css

      # Python
      python

      # Go
      go gomod gosum gowork

      # C / C++
      c cpp cmake make

      # Git
      git_config git_rebase gitcommit gitignore gitattributes diff

      # Hyprland
      hyprlang

      # Nix / shell / config
      nix bash fish toml yaml ini dockerfile ssh_config

      # Lua / Neovim / docs
      lua luadoc vim vimdoc query regex markdown markdown_inline

      # Misc
      comment printf xml sql rust
    ];

    extras = {
      lang.nix.enable = true;
      # lang.python.enable = true;
      # lang.go.enable = true;
      # lang.typescript.enable = true;
      # lang.clangd.enable = true;
    };

    extraPackages = with pkgs; [
      yazi
      wl-clipboard
    ];
  };
}

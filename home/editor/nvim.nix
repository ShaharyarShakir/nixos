{ pkgs, inputs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    configFiles = ./lazyvim;

    treesitterParsers = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      lua
      nix
      bash
      vim
      vimdoc
      markdown
      markdown_inline
      query
      regex
      json
      yaml
      toml
      python
      javascript
      typescript
      tsx
      html
      css
    ];

    extras = {
      lang.nix.enable = true;
    };

    extraPackages = with pkgs; [
      yazi
      wl-clipboard
    ];
  };
}

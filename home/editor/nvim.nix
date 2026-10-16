{ pkgs, inputs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    configFiles = ./lazyvim;

    treesitterParsers = pkgs.vimPlugins.nvim-treesitter.allGrammars;

    extras = {
      lang.nix.enable = true;
    };

    extraPackages = with pkgs; [
      yazi
      wl-clipboard
    ];
  };
}

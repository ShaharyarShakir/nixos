{ pkgs, lib, inputs, ... }:
let
  grammars = pkgs.vimPlugins.nvim-treesitter.builtGrammars;

  wanted = [
    # JS / TS / web
    "javascript" "typescript" "tsx" "jsdoc" "json" "html" "css"
    # Python
    "python"
    # Go
    "go" "gomod" "gosum" "gowork"
    # C / C++
    "c" "cpp" "cmake" "make"
    # Git
    "git_config" "git_rebase" "gitcommit" "gitignore" "gitattributes" "diff"
    # Hyprland
    "hyprlang"
    # Nix / shell / config
    "nix" "bash" "fish" "toml" "yaml" "ini" "dockerfile" "ssh_config"
    # Lua / Neovim / docs
    "lua" "luadoc" "vim" "vimdoc" "query" "regex" "markdown" "markdown_inline"
    # Misc
    "comment" "printf" "xml" "sql" "rust" "ron" "rasi"
  ];

  available = builtins.filter (n: grammars ? ${n}) wanted;
  missing   = builtins.filter (n: !(grammars ? ${n})) wanted;
in
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    pluginSource = "nixpkgs";
    configFiles = ./lazyvim;

    # warns at build time if any name was skipped
    treesitterParsers =
      lib.warnIf (missing != [ ])
        "nvim.nix: skipped unavailable treesitter parsers: ${toString missing}"
        (map (n: grammars.${n}) available);

    extras = {
      lang.nix.enable = true;
    };

    extraPackages = with pkgs; [
      yazi
      wl-clipboard
    ];
  };
}

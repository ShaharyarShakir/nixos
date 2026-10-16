{ pkgs, inputs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;

    # Your layer: config/ and plugins/ get copied over the defaults
    configFiles = ./lazyvim;
    treesitterParsers = true;
    # Replaces lazyvim.json: enable the same extras you had before
    extras = {
      lang.nix.enable = true;
      # lang.python = {
      #   enable = true;
      #   installDependencies = true;
      #   installRuntimeDependencies = true;
      # };
    };

    # Tools your own plugin files need
    extraPackages = with pkgs; [
      yazi          # yazi.lua
      wl-clipboard  # use xclip on X11
    ];
  };
}

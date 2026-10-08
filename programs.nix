{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    kitty
    noctalia
    nautilus
    brave
    git
    rofi
    incus-ui-canonical
   sddm-astronaut
  ];

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

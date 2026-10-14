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
    talosctl
    blender
    vscode
    zed-editor
    godot
    google-chrome
    obs-studio
    vlc
    devenv
    neovim
    cliphist
    wl-clipboard
    wofi
  ];

}

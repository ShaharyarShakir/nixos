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
}

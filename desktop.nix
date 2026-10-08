{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "sddm-astronaut-theme";

    extraPackages = [
      pkgs.sddm-astronaut
    ];
  };
}

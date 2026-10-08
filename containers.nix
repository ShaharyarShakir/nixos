{ config, pkgs, ... }:

{
  # Incus
  virtualisation.incus.enable = true;

  # Docker
  virtualisation.docker.enable = true;
}

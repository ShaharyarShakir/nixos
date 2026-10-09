{ config, pkgs, ... }:
{
  virtualisation.incus.enable = true;
  virtualisation.docker.enable = true;

  systemd.services.incus.environment.INCUS_UI =
    "${pkgs.incus-ui-canonical}";
}

{ config, lib, pkgs, ... }:

let
  huskerDataDir = "/home/shaharyar/.local/share/husker";
  huskerBin = "/home/shaharyar/.local/bin/husker";
in
{
  environment.systemPackages = with pkgs; [
    firecracker
    iproute2
    iptables
    nftables
  ];

  environment.etc."husker/config.toml".text = ''
    data_dir = "${huskerDataDir}"
    default_kernel = "${huskerDataDir}/kernels/vmlinux"
    default_rootfs = "${huskerDataDir}/images/alpine-x86_64.ext4"
  '';

  systemd.services.husker = {
    description = "Husker microVM manager";
    after = [
      "network-online.target"
      "nftables.service"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HOME = "/root";
      PATH = lib.makeBinPath [
        pkgs.coreutils
        pkgs.iproute2
        pkgs.iptables
        pkgs.nftables
        pkgs.firecracker
      ];
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${huskerBin} daemon";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStopSec = 30;
      KillSignal = "SIGTERM";
    };
  };
}

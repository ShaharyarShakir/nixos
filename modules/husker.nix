{ config, lib, pkgs, inputs, ... }:

let
  husker = inputs.self.packages.${pkgs.system}.husker;
  huskerDataDir = "/home/shaharyar/.local/share/husker";
in
{
  environment.systemPackages = [
    husker
    pkgs.firecracker
    pkgs.iproute2
    pkgs.iptables
    pkgs.nftables
  ];

  environment.etc."husker/config.toml".text = ''
    data_dir = "${huskerDataDir}"
    default_kernel = "${huskerDataDir}/kernels/vmlinux"
    default_rootfs = "${huskerDataDir}/images/alpine-x86_64.ext4"
    firecracker_bin = "${pkgs.firecracker}/bin/firecracker"
    ovmf_code = "${pkgs.OVMF.fd}/FV/OVMF_CODE.fd"
    ovmf_vars = "${pkgs.OVMF.fd}/FV/OVMF_VARS.fd"
  '';

  systemd.services.husker = {
    description = "Husker microVM manager";

    # Ensure network interfaces are ready before initializing the bridge NAT table
    after = [
      "network-pre.target"
      "network-setup.service"
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    path = with pkgs; [
      coreutils
      iproute2
      iptables
      nftables
      firecracker
    ];

    environment = {
      HOME = "/root";
      HUSKER_DATA_DIR = huskerDataDir;
      HUSKER_DEFAULT_KERNEL = "${huskerDataDir}/kernels/vmlinux";
      HUSKER_DEFAULT_ROOTFS = "${huskerDataDir}/images/alpine-x86_64.ext4";
      HUSKER_FIRECRACKER_BIN = "${pkgs.firecracker}/bin/firecracker";
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${husker}/bin/husker daemon";
      Restart = "on-failure";
      RestartSec = 3;
      TimeoutStopSec = 30;
      KillSignal = "SIGTERM";
    };
  };
}

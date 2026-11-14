{ pkgs, inputs, ... }:

let
  multipass = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.multipass;
in
{
  environment.systemPackages = [ multipass ];

  networking.firewall.trustedInterfaces = [
    "mpqemubr0"
    "mpqemubrzone1"
    "mpqemubrzone2"
    "mpqemubrzone3"
  ];

  systemd.services.multipass = {
    description = "Multipass daemon";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    path = with pkgs; [ qemu_kvm dnsmasq iproute2 iptables ];

    environment = {
      XDG_DATA_HOME = "/var/lib/multipass/data";
      XDG_CACHE_HOME = "/var/lib/multipass/cache";
      XDG_CONFIG_HOME = "/var/lib/multipass/config";
    };

    serviceConfig = {
      ExecStart = "${multipass}/bin/multipassd --logger platform --verbosity info";
      Restart = "on-failure";
      TimeoutStopSec = 300;
      StateDirectory = "multipass";
      CacheDirectory = "multipass";
      WorkingDirectory = "/var/lib/multipass";
    };
  };
}

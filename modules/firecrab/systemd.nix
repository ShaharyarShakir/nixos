{ config, lib, pkgs, ... }:

let
  cfg = config.services.firecrab;

  firecrabLib = "${cfg.package}/lib/firecrab";
  firecrabShare = "${cfg.package}/share/firecrab";

  helperLauncher = pkgs.writeShellScript "firecrab-net-helper-start" ''
    set -eu

    helper_uid="$(${pkgs.coreutils}/bin/id -u ${cfg.user})"

    export FIRECRAB_NET_HELPER_ALLOWED_UID="$helper_uid"

    exec ${firecrabLib}/firecrab-helper
  '';
in
{
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.package != null;
        message = "services.firecrab.package must be configured.";
      }
      {
        assertion = cfg.firecracker.package != null;
        message = "services.firecrab.firecracker.package must be configured.";
      }
    ];

    # FireCrab MicroNetworks require host-level IPv4 forwarding.
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # ----------------------------------------------------------
    # Privileged host networking helper
    # ----------------------------------------------------------

    systemd.services.firecrab-net-helper = {
      description = "FireCrab privileged host networking helper";

      wantedBy = [ "multi-user.target" ];

      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      before = [ "firecrab-api.service" ];

      path = [
        cfg.package
        cfg.firecracker.package
        pkgs.bash
        pkgs.coreutils
        pkgs.findutils
        pkgs.gnutar
        pkgs.gzip
        pkgs.zstd
        pkgs.curl
        pkgs.git
        pkgs.openssh
        pkgs.iproute2
        pkgs.nftables
        pkgs.iptables
        pkgs.dnsmasq
        pkgs.conntrack-tools
        pkgs.e2fsprogs
        pkgs.fakeroot
      ];

      environment = {
        PREFIX = cfg.package;
        FIRECRAB_LIBDIR = firecrabLib;
        CONFDIR = cfg.configDir;
        UNITDIR = "/run/systemd/system";
      };

      serviceConfig = {
        Type = "simple";

        User = "root";
        Group = cfg.group;

        RuntimeDirectory = "firecrab";
        RuntimeDirectoryMode = "0751";

        ExecStart = "${helperLauncher}";

        Restart = "on-failure";
        RestartSec = 2;

        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_RAW"
          "CAP_NET_BIND_SERVICE"
          "CAP_SETUID"
          "CAP_SETGID"
          "CAP_KILL"
          "CAP_CHOWN"
        ];

        NoNewPrivileges = true;
        ProtectHome = true;
        ProtectSystem = "full";

        ReadWritePaths = [
          "/run/firecrab"
          cfg.dataDir
          cfg.configDir
          "/run/systemd/system"
        ];
      };
    };

    # ----------------------------------------------------------
    # API and dashboard
    # ----------------------------------------------------------

    systemd.services.firecrab-api = {
      description = "FireCrab API and dashboard";

      wantedBy = [ "multi-user.target" ];

      after = [
        "firecrab-net-helper.service"
        "network-online.target"
      ];

      wants = [
        "firecrab-net-helper.service"
        "network-online.target"
      ];

      path = [
        cfg.package
        cfg.firecracker.package
        pkgs.bash
        pkgs.binutils
        pkgs.bzip2
        pkgs.coreutils
        pkgs.curl
        pkgs.e2fsprogs
        pkgs.fakeroot
        pkgs.file
        pkgs.findutils
        pkgs.gnugrep
        pkgs.gnused
        pkgs.gnutar
        pkgs.gzip
        pkgs.git
        pkgs.iproute2
        pkgs.iptables
        pkgs.lz4
        pkgs.lzop
        pkgs.nftables
        pkgs.openssh
        pkgs.dnsmasq
        pkgs.conntrack-tools
        pkgs.xz
        pkgs.zstd
      ];

      environment = {
        FIRECRAB_IMAGE_ROOT = "${cfg.dataDir}/images";
        FIRECRAB_STATIC_ROOT = "${firecrabShare}/dashboard";
        FIRECRAB_CI_DEPLOY = "1";

        PREFIX = cfg.package;
        FIRECRAB_LIBDIR = firecrabLib;
        DATADIR = cfg.dataDir;
      };

      serviceConfig = {
        Type = "simple";

        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = cfg.dataDir;

        EnvironmentFile = "-${cfg.configDir}/api.env";

        ExecStart = "${firecrabLib}/firecrab-api";

        Restart = "on-failure";
        RestartSec = 2;

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";

        ReadWritePaths = [
          cfg.dataDir
          "-/run/firecrab"
        ];
      };
    };
  };
}

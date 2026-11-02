{ config, lib, pkgs, ... }:

let
  firecrabPath =
    "/run/current-system/sw/bin:/usr/local/bin:"
    + lib.makeBinPath [
      pkgs.iproute2
      pkgs.nftables
      pkgs.dnsmasq
      pkgs.conntrack-tools
      pkgs.curl
      pkgs.gnutar
      pkgs.zstd
    ];
in
{
  # ------------------------------------------------------------
  # FireCrab system account
  # Preserve the IDs from the existing installation.
  # ------------------------------------------------------------

  users.groups.firecrab = {
    gid = 986;
  };

  users.users.firecrab = {
    isSystemUser = true;
    uid = 992;
    group = "firecrab";
    home = "/var/lib/firecrab";
    createHome = false;
    extraGroups = [ "kvm" ];
  };

  # ------------------------------------------------------------
  # Privileged FireCrab host helper
  # ------------------------------------------------------------

  systemd.services.firecrab-helper = {
    description = "FireCrab privileged host helper";

    wantedBy = [ "multi-user.target" ];

    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    before = [ "firecrab-api.service" ];

    environment = {
      FIRECRAB_NET_HELPER_ALLOWED_UID = "992";
      PREFIX = "/usr/local";
      FIRECRAB_LIBDIR = "/usr/local/lib/firecrab";
      CONFDIR = "/etc/firecrab";
      UNITDIR = "/run/systemd/system";
    };

    serviceConfig = {
      Type = "simple";

      User = "root";
      Group = "firecrab";

      RuntimeDirectory = "firecrab";
      RuntimeDirectoryMode = "0751";

      Environment = [
        "PATH=${lib.mkForce firecrabPath}"
      ];

      ExecStart = "/usr/local/lib/firecrab/firecrab-helper";

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
        "/usr/local/lib/firecrab"
        "/usr/local/share/firecrab"
        "/usr/local/bin"
        "/var/lib/firecrab"
        "/etc/firecrab"
        "/run/systemd/system"
      ];
    };
  };

  # ------------------------------------------------------------
  # FireCrab API and dashboard
  # ------------------------------------------------------------

  systemd.services.firecrab-api = {
    description = "FireCrab API and dashboard";

    wantedBy = [ "multi-user.target" ];

    after = [
      "firecrab-helper.service"
      "network-online.target"
    ];

    wants = [
      "firecrab-helper.service"
      "network-online.target"
    ];

    environment = {
      FIRECRAB_IMAGE_ROOT = "/var/lib/firecrab/images";
      FIRECRAB_STATIC_ROOT = "/usr/local/share/firecrab/dashboard";
      FIRECRAB_CI_DEPLOY = "1";

      PREFIX = "/usr/local";
      FIRECRAB_LIBDIR = "/usr/local/lib/firecrab";
      DATADIR = "/var/lib/firecrab";
    };

    serviceConfig = {
      Type = "simple";

      User = "firecrab";
      Group = "firecrab";

      WorkingDirectory = "/var/lib/firecrab";

      EnvironmentFile = "-/etc/firecrab/api.env";

      Environment = [
        "PATH=${lib.mkForce firecrabPath}"
      ];

      ExecStart = "/usr/local/lib/firecrab/firecrab-api";

      Restart = "on-failure";
      RestartSec = 2;

      StateDirectory = "firecrab";
      StateDirectoryMode = "0750";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectSystem = "full";

      ReadWritePaths = [
        "/var/lib/firecrab"
        "-/run/firecrab"
      ];
    };
  };
}


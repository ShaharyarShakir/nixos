{ lib, ... }:

{
  options.services.firecrab = {
    enable = lib.mkEnableOption "FireCrab VM management platform";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "FireCrab application package.";
    };

    firecracker.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "Firecracker microVM runtime package.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "firecrab-nixos";
      description = "FireCrab service account.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "firecrab-nixos";
      description = "FireCrab service group.";
    };

    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "UID for the FireCrab service account. Leave null to let NixOS allocate it.";
    };

    gid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "GID for the FireCrab service group. Leave null to let NixOS allocate it.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/firecrab-nixos";
      description = "FireCrab application and VM data directory.";
    };

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "/etc/firecrab-nixos";
      description = "FireCrab configuration directory.";
    };
  };
}

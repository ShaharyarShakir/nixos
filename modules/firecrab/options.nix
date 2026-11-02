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
      description = "System user for the FireCrab deployment.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "firecrab-nixos";
      description = "System group for the FireCrab deployment.";
    };

    uid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Optional UID for the FireCrab system user.";
    };

    gid = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Optional GID for the FireCrab system group.";
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

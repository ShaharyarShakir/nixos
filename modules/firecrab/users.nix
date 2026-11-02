{ config, lib, ... }:

let
  cfg = config.services.firecrab;
in
{
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = lib.mkIf (cfg.gid != null) {
      gid = cfg.gid;
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = false;

      extraGroups = [ "kvm" ];
      description = "FireCrab NixOS service account";
    } // lib.optionalAttrs (cfg.uid != null) {
      uid = cfg.uid;
    };
  };
}

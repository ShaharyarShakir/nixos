{ config, lib, ... }:

let
  cfg = config.services.firecrab;
in
{
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = if cfg.gid == null then {} else { gid = cfg.gid; };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = false;

      extraGroups = [ "kvm" ];
      description = "FireCrab NixOS service account";
    } // (if cfg.uid == null then {} else { uid = cfg.uid; });
  };
}

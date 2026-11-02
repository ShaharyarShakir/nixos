{ config, lib, ... }:

let
  cfg = config.services.firecrab;
in
{
  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = {
      gid = cfg.gid;
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      uid = cfg.uid;
      group = cfg.group;

      home = cfg.dataDir;
      createHome = false;

      extraGroups = [ "kvm" ];

      description = "FireCrab VM management service";
    };
  };
}

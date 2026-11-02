{ config, lib, ... }:

let
  cfg = config.services.firecrab;

  user = cfg.user;
  group = cfg.group;
in
{
  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      # Application data
      "d ${cfg.dataDir} 0750 ${user} ${group} - -"

      # Database and VM artifacts
      "d ${cfg.dataDir}/data 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/data/vms 0750 ${user} ${group} - -"

      # Images and updates
      "d ${cfg.dataDir}/images 0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/updates 0750 ${user} ${group} - -"

      # Configuration is managed by root, readable by the service group
      "d ${cfg.configDir} 0750 root ${group} - -"
    ];
  };
}

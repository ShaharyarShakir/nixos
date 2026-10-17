{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
  ];

  users.users.shaharyar.extraGroups = [
    "libvirtd"
    "kvm"
  ];
}

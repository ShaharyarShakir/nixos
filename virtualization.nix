
{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    qemuPackage = pkgs.qemu_kvm;
  };

  environment.systemPackages = with pkgs; [
    qemu_kvm
    libvirt
    virt-manager
    virt-viewer
  ];

  users.users.shaharyar.extraGroups = [
    "libvirtd"
  ];
}

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

  environment.etc."qemu/firmware/60-edk2-x86_64.json".source =
  "${pkgs.qemu}/share/qemu/firmware/60-edk2-x86_64.json";  

  environment.systemPackages = with pkgs; [
    virt-viewer
  ];

  users.users.shaharyar.extraGroups = [
    "libvirtd"
    "kvm"
  ];
}

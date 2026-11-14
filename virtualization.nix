{ pkgs, ... }:

{
  services.snap.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
  ];

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

  systemd.tmpfiles.rules = [
    "L+ /usr/libexec/virtiofsd - - - - ${pkgs.virtiofsd}/bin/virtiofsd"
    "L+ /usr/lib/systemd/systemd-ssh-proxy - - - - ${pkgs.systemd}/lib/systemd/systemd-ssh-proxy"
  ];

  users.users.shaharyar.extraGroups = [
    "libvirtd"
    "kvm"
  ];
}

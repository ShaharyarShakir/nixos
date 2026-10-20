{ pkgs, inputs, ... }:

{
  # Container support
  virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
  };

  # VM management and development tools
  environment.systemPackages = [
    pkgs.lima
    inputs.voom.packages.${pkgs.system}.default
    pkgs.sshfs
  ];

  # Allow the user to manage development environments
  users.users.shaharyar.extraGroups = [
    "podman"
    "libvirtd"
    "kvm"
  ];
}


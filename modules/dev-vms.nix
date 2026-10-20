
{ pkgs, inputs, ... }:

{
  # 1. Enable background services required by the virtual machine managers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # 2. Inject both tools globally into your system user profile
  environment.systemPackages = [
    pkgs.lima                                      # Installed from standard nixpkgs channel
    inputs.self.packages.${pkgs.system}.flintlock  # Pulled locally from our packages recipe
    pkgs.sshfs                                     # For zero-config fallback storage sharing
  ];

  # 3. Handle groups  don't need 'sudo' to manage environments
  users.users.shaharyar.extraGroups = [ "podman" "libvirtd" "kvm" ];
}

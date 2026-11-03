{ ... }:

{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 12 * 1024;
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };
}

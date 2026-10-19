{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.system}.nvidia-sync
  ];
}
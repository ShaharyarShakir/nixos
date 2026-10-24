{
  description = "Shaharyar's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
nix-snapd = {
  url = "github:nix-community/nix-snapd";
  inputs.nixpkgs.follows = "nixpkgs";
};
voom = {
  url = "github:mjrusso/voom";
};
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cubic-src = {
      url = "github:cubic-vm/cubic";
      flake = false;
    };  
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      cubic-src,
    nix-snapd,
      ...
    }@inputs:
    {
      # =========================================================================
      # PACKAGES
      # =========================================================================
      packages.x86_64-linux.cubic =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        in
        pkgs.callPackage ./packages/cubic.nix {
          src = cubic-src;
          qemu = pkgs.qemu_kvm;
          OVMF = pkgs.OVMF.fd;
        };
     
      packages.x86_64-linux.nvidia-sync =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in
        pkgs.callPackage ./packages/nvidia-sync.nix { };

      # =========================================================================
      # MODULE REFS
      # =========================================================================
      nixosModules.nvidia-sync = import ./modules/nvidia-sync.nix;
      nixosModules.cubic = import ./modules/cubic.nix;
      nixosModules.dev-vms = import ./modules/lima.nix; 

      # =========================================================================
      # SYSTEM CONFIGURATION
      # =========================================================================
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          ./modules/cubic.nix
          ./modules/lima.nix
          ./modules/nvidia-sync.nix
            nix-snapd.nixosModules.default
           home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.shaharyar = import ./home/home.nix;
          }
        ];
      };
    };
}


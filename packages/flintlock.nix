{
  lib,
  buildGoModule,
  pkg-config,
  btrfs-progs,
  devmapper,
  src,
}:

buildGoModule {
  pname = "flintlock";
  version = "unstable";

  inherit src;

  # Nix requires a vendor hash for Go modules to maintain reproducibility
  vendorHash = lib.fakeVendorHash; 

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ btrfs-progs devmapper ];

  meta = {
    description = "A lightweight microVM manager for Firecracker";
    homepage = "https://github.com";
    license = lib.licenses.asl20;
    mainProgram = "fcli";
    platforms = [ "x86_64-linux" ];
  };
}


{
  lib,
  buildGoModule,
  pkg-config,
  btrfs-progs,
  lvm2,
  src,
}:

buildGoModule {
  pname = "flintlock";
  version = "unstable";

  inherit src;

  # Build only the root Go module's executables.
  subPackages = [
    "cmd/flintlockd"
    "cmd/flintlock-metrics"
    "cmd/flintlock-provision"
  ];

  vendorHash = "sha256-waXQlWP9aHmbk0Y0iPHf8EH4CjlWFfSRHt4UfYTDonY=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ btrfs-progs lvm2 ];

  meta = {
    description = "A service for managing microVM lifecycles";
    homepage = "https://github.com/liquidmetal-dev/flintlock";
    license = lib.licenses.mpl20;
    mainProgram = "flintlockd";
    platforms = [ "x86_64-linux" ];
  };
}


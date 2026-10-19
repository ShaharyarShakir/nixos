{
  lib,
  rustPlatform,
  makeWrapper,
  pkg-config,
  openssl,
  qemu,
  OVMF,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "cubic";
  version = "unstable";

  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/cubic \
      --prefix PATH : ${lib.makeBinPath [ qemu ]} \
      --set CUBIC_QEMU_FW_AMD64 \
        "${OVMF}/FV/OVMF_CODE.fd"
  '';

  meta = {
    description = "A lightweight Linux virtual machine manager";
    homepage = "https://cubic-vm.org/";
    mainProgram = "cubic";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}

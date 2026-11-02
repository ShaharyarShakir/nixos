{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gnutar,
  gzip,
  glibc,
}:

let
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/SteelCrab/firecrab/releases/download/v${version}/firecrab-host-x86_64-gnu.tar.gz";
    hash = "sha256-Nqr3+3MeDtkbzIfTXge04S25HYQ22C7xEnfvg0om4VQ=";
  };
in
stdenv.mkDerivation {
  pname = "firecrab";
  inherit version src;

  unpackPhase = ''
    runHook preUnpack

    mkdir -p source
    tar -xzf "$src" -C source

    runHook postUnpack
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    gnutar
    gzip
  ];

  # Libraries required by the dynamically linked release binaries.
  buildInputs = [
    glibc
    stdenv.cc.cc.lib
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    cd source

    # Main executable and private runtime binaries.
    install -Dm755 firecrab \
      "$out/bin/firecrab"

    install -Dm755 firecrab-api \
      "$out/lib/firecrab/firecrab-api"

    install -Dm755 firecrab-helper \
      "$out/lib/firecrab/firecrab-helper"

    install -Dm755 firecrab-net-helper \
      "$out/lib/firecrab/firecrab-net-helper"

    install -Dm755 firecrab-ingress \
      "$out/lib/firecrab/firecrab-ingress"

    install -Dm755 firecrab-guest-console \
      "$out/lib/firecrab/firecrab-guest-console"

    # Supporting extraction utilities.
    install -Dm755 extract-vmlinux \
      "$out/lib/firecrab/extract-vmlinux"

    install -Dm755 extract-arm64-image \
      "$out/lib/firecrab/extract-arm64-image"

    # Dashboard assets.
    mkdir -p "$out/share/firecrab"
    cp -a dashboard "$out/share/firecrab/dashboard"

    # Original systemd templates.
    cp -a systemd "$out/share/firecrab/systemd"

    # Ingress configuration and third-party notices.
    cp -a ingress "$out/share/firecrab/ingress"

    # Release compliance files.
    install -Dm644 LICENSE \
      "$out/share/firecrab/LICENSE"

    install -Dm644 licenses/GPL-2.0-only.txt \
      "$out/share/firecrab/licenses/GPL-2.0-only.txt"

    install -Dm644 THIRD_PARTY_NOTICES.txt \
      "$out/share/firecrab/THIRD_PARTY_NOTICES.txt"

    install -Dm644 release-license-inventory.json \
      "$out/share/firecrab/release-license-inventory.json"

    install -Dm644 guest-console/LICENSE.musl \
      "$out/share/firecrab/guest-console/LICENSE.musl"

    runHook postInstall
  '';

  meta = {
    description = "FireCrab virtual machine management platform";
    homepage = "https://github.com/SteelCrab/firecrab";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "firecrab";
  };
}

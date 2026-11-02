{ lib, stdenvNoCC, fetchurl, gnutar, gzip }:

let
  version = "1.17.0";
  archiveName = "firecracker-v${version}-x86_64.tgz";

  src = fetchurl {
    url = "https://github.com/firecracker-microvm/firecracker/releases/download/v${version}/${archiveName}";
    hash = "sha256-BglKEQiunoKqTCOndaqSdY9T8RddQiJw2dYWLLmt5Vg=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "firecracker";
  inherit version src;

  nativeBuildInputs = [
    gnutar
    gzip
  ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/doc/firecracker"

    tar -xzf "$src" -C "$TMPDIR"

    release_dir="$TMPDIR/release-v${version}-x86_64"

    install -Dm755 \
      "$release_dir/firecracker-v${version}-x86_64" \
      "$out/bin/firecracker"

    install -Dm644 \
      "$release_dir/LICENSE" \
      "$out/share/doc/firecracker/LICENSE"

    install -Dm644 \
      "$release_dir/NOTICE" \
      "$out/share/doc/firecracker/NOTICE"

    install -Dm644 \
      "$release_dir/THIRD-PARTY" \
      "$out/share/doc/firecracker/THIRD-PARTY"

    runHook postInstall
  '';

  meta = {
    description = "Secure and lightweight virtual machine monitor";
    homepage = "https://firecracker-microvm.github.io/";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "firecracker";
  };
}

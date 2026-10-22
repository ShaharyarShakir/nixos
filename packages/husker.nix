{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:

let
  version = "0.4.36";

  archive = fetchurl {
    url = "https://github.com/rvben/husker/releases/download/v${version}/husker-v${version}-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-9SU3VHFrAXq/fxCl1nEXyA0erMu2aE2jMgDZsf3qkbc=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "husker";
  inherit version;

  src = archive;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -d "$out/bin"
    tar -xzf "$src" -C "$out/bin" ./husker
    chmod 755 "$out/bin/husker"

    runHook postInstall
  '';

  meta = {
    description = "MicroVM manager using Firecracker";
    homepage = "https://github.com/rvben/husker";
    mainProgram = "husker";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
  };
}


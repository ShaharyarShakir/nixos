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

  dontUnpack = false;
  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./husker "$out/bin/husker"

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


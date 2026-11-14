{ lib, stdenvNoCC, src, multipass-src }:

stdenvNoCC.mkDerivation {
  pname = "out-ptr";
  version = "2025-04-07";
  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/include" "$out/share/out_ptr"
    cp -r include/ztd "$out/include/"

    cp --no-preserve=mode \
      ${multipass-src}/3rd-party/vcpkg-ports/out-ptr/out_ptr-config.cmake \
      "$out/share/out_ptr/"

    runHook postInstall
  '';

  meta = {
    description = "Header-only std::out_ptr implementation";
    homepage = "https://github.com/soasis/out_ptr";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}

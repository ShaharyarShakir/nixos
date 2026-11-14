{ lib, stdenv, cmake, src, multipass-src }:

stdenv.mkDerivation {
  pname = "xz-embedded";
  version = "2024-12-30";
  inherit src;

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    cp --no-preserve=mode \
      ${multipass-src}/3rd-party/vcpkg-ports/xz-embedded/CMakeLists.txt \
      CMakeLists.txt
  '';

  meta = {
    description = "xz embedded library";
    homepage = "https://github.com/tukaani-project/xz-embedded";
    license = lib.licenses.publicDomain;
    platforms = [ "x86_64-linux" ];
  };
}

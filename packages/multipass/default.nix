{ lib, stdenv, src, cmake, ninja, pkg-config, git, perl, python3
, qt6, grpc, protobuf, openssl, boost, fmt, yaml-cpp, libssh, neargye-semver
, out_ptr, xz_embedded, scope_guard
, libapparmor, rustPlatform, cargo, rustc
}:

stdenv.mkDerivation rec {
  pname = "multipass";
  version = "1.17.1";
  inherit src;

  cargoRoot = "rxx";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src cargoRoot;
    hash = lib.fakeHash;
  };

  postPatch = ''
    # vcpkg needs network access; remove its bootstrap and toolchain block
    perl -0pi -e 's/message\(STATUS "Bootstrapping vcpkg\.\.\."\).*?CACHE STRING "Vcpkg toolchain file"\)\n//s' CMakeLists.txt

    # nixpkgs Boost does not ship a BoostConfig.cmake for the header-only uuid package
    perl -0pi -e 's/find_package\(Boost CONFIG REQUIRED COMPONENTS json uuid\)/find_package(Boost CONFIG REQUIRED COMPONENTS json)/' CMakeLists.txt

    # nixpkgs OpenSSL does not provide an OpenSSLConfig.cmake; use CMake's module finder instead
    sed -i -E '/find_package\(OpenSSL/ s/ (CONFIG|NO_MODULE)//' CMakeLists.txt

    # no .git in the Nix store: set the version directly in CMakeLists.txt
    perl -0pi -e 's/determine_version\(MULTIPASS_VERSION\)/set(MULTIPASS_VERSION "1.17.1")/' CMakeLists.txt

    # QEMU comes from nixpkgs at runtime, not from vcpkg
    sed -i -E '/qemu-(system|img)-install-and-copy/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    git
    perl
    python3
    protobuf
    grpc
    qt6.wrapQtAppsHook
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    qt6.qtbase
    openssl
    grpc
    protobuf
    boost
    fmt
    yaml-cpp
    libssh
    neargye-semver
    out_ptr
    xz_embedded
    scope_guard
    libapparmor
  ];

  cmakeFlags = [
    "-DMULTIPASS_ENABLE_FLUTTER_GUI=OFF"
    "-DMULTIPASS_ENABLE_TESTS=OFF"
    "-DFORCE_ENABLE_VIRTUALBOX=OFF"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  meta = {
    description = "Ubuntu VM manager";
    homepage = "https://multipass.run";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "multipass";
  };
}

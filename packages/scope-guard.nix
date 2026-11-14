{ lib, stdenvNoCC, src }:

stdenvNoCC.mkDerivation {
  pname = "scope-guard";
  version = "1.1.0";
  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 scope_guard.hpp "$out/include/scope_guard.hpp"
    runHook postInstall
  '';

  meta = {
    description = "A simple C++ scope guard implementation";
    homepage = "https://github.com/ricab/scope_guard";
    license = lib.licenses.unlicense;
    platforms = [ "x86_64-linux" ];
  };
}

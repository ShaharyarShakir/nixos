{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv, 
}:

let
  version = "0.4.36";

  archive = fetchurl {
    url = "https://github.com{version}/husker-v${version}-x86_64-unknown-linux-gnu.tar.gz";
    hash = "sha256-9SU3VHFrAXq/fxCl1nEXyA0erMu2aE2jMgDZsf3qkbc=";
  };

  # Extract raw binary
  husker-bin = stdenvNoCC.mkDerivation {
    pname = "husker-bin";
    inherit version;
    src = archive;
    dontUnpack = true;
    installPhase = ''
      install -d "$out/bin"
      tar -xzf "$src" -C "$out/bin" ./husker
      chmod 755 "$out/bin/husker"
    '';
  };
in

buildFHSEnv {
  name = "husker";
  runScript = "${husker-bin}/bin/husker";
  
  targetPkgs = pkgs: with pkgs; [
    nftables
    iptables
    iproute2
    firecracker
    kmod       
    bash       
    coreutils
  ];

  meta = {
    description = "MicroVM manager using Firecracker";
    homepage = "https://github.com";
    mainProgram = "husker";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
  };
}

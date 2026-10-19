{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
 writeShellScriptBin,
  autoPatchelfHook,
  wrapGAppsHook3,
  makeWrapper,
  openssh,
  kitty,
  # Native runtime dependencies
  stdenv,
  glib,
  gtk3,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  pango,
  gdk-pixbuf,
  nss,
  nspr,
  dbus,
  cups,
  libsecret,
  libnotify,
  libappindicator-gtk3,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libxcb,
  libxkbcommon,
  libXtst,
  libgbm,
  libdrm,
  alsa-lib,
  expat,
  libuuid,
  zlib,
  systemd,
}:
let
  # Shim so NVIDIA Sync's "xdg-terminal-exec" lookup launches kitty
  xdg-terminal-exec-kitty = writeShellScriptBin "xdg-terminal-exec" ''
    if [ "''${1:-}" = "-e" ] || [ "''${1:-}" = "--" ]; then
      shift
    fi
    exec ${lib.getExe kitty} "$@"
  '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nvidia-sync";
  version = "0.117.3";

  src = fetchurl {
    url = "https://workbench.download.nvidia.com/stable/linux/debian/pool/proprietary/n/nvidia-sync/nvidia-sync_0.117.3-12_amd64.deb";
    sha256 = "a227570a55de92827b40e13782d4a074c6bd0a4a31d9b84c0fd7bf943f86a92f";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    glib
    gtk3
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    pango
    gdk-pixbuf
    nss
    nspr
    dbus
    cups
    libsecret
    libnotify
    libappindicator-gtk3
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
    libXtst
    libgbm
    libdrm
    alsa-lib
    expat
    libuuid
    zlib
    systemd
  ];

  
installPhase = ''
  runHook preInstall

  dpkg-deb -x "$src" unpacked

  mkdir -p "$out/lib/nvidia-sync"
  cp -a "unpacked/opt/NVIDIA Sync/." "$out/lib/nvidia-sync/"

  install -Dm644 \
    "unpacked/usr/share/icons/hicolor/512x512/apps/nvidia-sync.png" \
    "$out/share/icons/hicolor/512x512/apps/nvidia-sync.png"

  install -Dm644 \
    "unpacked/usr/share/applications/nvidia-sync.desktop" \
    "$out/share/applications/nvidia-sync.desktop"

  mkdir -p "$out/bin"

  makeWrapper "$out/lib/nvidia-sync/nvidia-sync" \
    "$out/bin/nvidia-sync" \
    --prefix PATH : ${lib.makeBinPath [ openssh xdg-terminal-exec-kitty ]}

  substituteInPlace "$out/share/applications/nvidia-sync.desktop" \
    --replace-fail \
      '"/opt/NVIDIA Sync/nvidia-sync"' \
      "$out/bin/nvidia-sync"

  runHook postInstall
'';

  meta = {
    description = "NVIDIA Sync SSH tunneling and remote development utility";
    homepage = "https://workbench.download.nvidia.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "nvidia-sync";
  };
})

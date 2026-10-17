{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      # C/C++ runtime
      stdenv.cc.cc.lib
      zlib
      expat

      # GLib and GTK
      glib
      gtk3
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      pango
      gdk-pixbuf

      # Browser and desktop integration
      nspr
      nss
      dbus
      cups
      libsecret
      libnotify

      # X11 and keyboard support
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libxcb
      libxkbcommon
      libXtst

      # Graphics, audio, and device access
      libgbm
      libdrm
      alsa-lib
      systemd

      # Other runtime dependencies
      libuuid
    ];
  };
}

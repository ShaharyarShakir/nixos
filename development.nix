{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Build essentials
    gcc
    gnumake
    binutils
    pkg-config

    # Native development
    clang
    cmake
    ninja
    meson

    # Debugging
    gdb
    lldb

    # General development utilities
    git-lfs
    curl
    wget
    unzip
    zip
    rsync
    jq
    tree

    # CLI developer tools
    ripgrep
    fd
    fzf
    bat
    eza
    lazygit
    yazi
  ];
}

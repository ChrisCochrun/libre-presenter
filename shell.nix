{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell rec {
  name = "lumina";

  nativeBuildInputs = [
    # ffmpeg
  ];

  buildInputs = [
    gcc
    stdenv
    gnumake
    gdb
    qtcreator
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.wrapQtAppsHook
    makeWrapper


    clang-tools
    clang
    libclang
    # clang-format
    qt5.qtbase
    qt5.qttools
    qt5.qtquickcontrols2
    qt5.qtx11extras
    qt5.qtmultimedia
    qt5.qtwayland
    qt5.qtwebengine
    libsForQt5.kirigami2
    # libsForQt5.breeze-icons
    # libsForQt5.breeze-qt5
    libsForQt5.qqc2-desktop-style
    libsForQt5.karchive
    libsForQt5.sonnet
    # libsForQt5.kirigami-addons
    # libsForQt5.ki18n
    # libsForQt5.kcoreaddons
    # libsForQt5.kguiaddons
    # libsForQt5.kconfig

    # podofo
    mpv
    ffmpeg_5-full
    # yt-dlp

    # Rust tools
    clippy
    rustc
    cargo
    rustfmt
    rust-analyzer
    corrosion
  ];
  
  # cargoDeps = rustPlatform.importCargoLock {
  #   lockFile = ./Cargo.lock;
  # };

  RUST_BACKTRACE = "full";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  CMAKE_C_COMPILER = "${gcc}/bin/gcc";
  CMAKE_CXX_COMPILER = "${gcc}/bin/g++";
  # QT_SCALE_FACTOR = 1;

  # This creates the proper qt env so that plugins are found right.
  shellHook = ''
    setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    echo "shellHook: setQtEnvironment = $setQtEnvironment"
    makeQtWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    sed "/^exec/d" -i "$setQtEnvironment"
    source "$setQtEnvironment"
  '';
}

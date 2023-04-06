{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell rec {
  name = "presenter";

  nativeBuildInputs = [
    gcc
    gnumake
    gdb
    qtcreator
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.wrapQtAppsHook
    makeWrapper
    # ffmpeg
  ];

  buildInputs = [
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
    libsForQt5.kirigami2
    # libsForQt5.breeze-icons
    # libsForQt5.breeze-qt5
    libsForQt5.qqc2-desktop-style
    libsForQt5.karchive
    # libsForQt5.kirigami-addons
    # libsForQt5.ki18n
    # libsForQt5.kcoreaddons
    # libsForQt5.kguiaddons
    # libsForQt5.kconfig

    podofo
    mpv
    ffmpeg_6-full
    # yt-dlp

    # Rust tools
    clippy
    rustc
    cargo
    rustfmt
    rust-analyzer
    corrosion
  ];
  
  RUST_BACKTRACE = 1;
  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
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

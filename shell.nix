{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell rec {
  name = "presenter-env";

  nativeBuildInputs = [
    gcc
    gnumake
    clang
    qtcreator
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    clang-tools
    # clang-format
    qt5.qtbase
    qt5.qttools
    qt5.qtquickcontrols2
    qt5.qtx11extras
    qt5.qtmultimedia
    qt5.qtwayland
    libsForQt5.kirigami2
    libsForQt5.breeze-icons
    libsForQt5.breeze-qt5
    libsForQt5.qqc2-desktop-style
    libsForQt5.karchive
    # libsForQt5.kirigami-addons
    libsForQt5.ki18n
    libsForQt5.kcoreaddons
    libsForQt5.kguiaddons

    podofo
    mpv
    # libsForQt5.kconfig
    # ffmpeg-full
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
  # This creates the proper qt env so that plugins are found right.
  shellHook = ''
    setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    echo "shellHook: setQtEnvironment = $setQtEnvironment"
    makeQtWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    sed "/^exec/d" -i "$setQtEnvironment"
    source "$setQtEnvironment"
  '';
}

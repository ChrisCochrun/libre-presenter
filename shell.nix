with import <nixpkgs> { };
pkgs.mkShell {
  name = "presenter-env";

  nativeBuildInputs = [
    gcc
    gnumake
    clang
    cmake
    extra-cmake-modules
    pkg-config
    # gccStdenv
    # stdenv
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtquickcontrols2
    qt5.qtx11extras
    qt5.qtmultimedia
    libsForQt5.kirigami2
    libsForQt5.ki18n
    libsForQt5.kcoreaddons
    mpv
    # libsForQt5.kconfig
    # ffmpeg-full
    # yt-dlp
  ];

  shellHook = ''
  '';
}

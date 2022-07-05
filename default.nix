{
  stdenv,
  lib,
  # qtx11extras,
  # qttools,
  # kglobalaccel,
  # kinit,
  # kwin,
  # kio,
  # kguiaddons,
  # kcoreaddons,
  # systemsettings,
  gcc,
  gnumake,
  clang,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qt5Full,
  clang-tools,
  qttools,
  qtquickcontrols2,
  qtx11extras,
  qtmultimedia,
  kirigami2,
  ki18n,
  kcoreaddons,
  # lightly-qt,
  mpv
}:

stdenv.mkDerivation rec {
  pname = "Libre Presenter";
  version = "0.0.0";

  nativeBuildInputs = [
    gcc
    gnumake
    clang
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
    # gccStdenv
    # stdenv
  ];

  buildInputs = [
    clang-tools
    qt5Full
    qttools
    qtquickcontrols2
    qtx11extras
    qtmultimedia
    kirigami2
    ki18n
    kcoreaddons
    # lightly-qt
    mpv
    # libsForQt5.kconfig
    # ffmpeg-full
    # yt-dlp
  ];

  # preConfigure = ''
  #   # local modulepath=$(kf5-config --install module)
  #   # local datapath=$(kf5-config --install data)
  #   # local servicespath=$(kf5-config --install services)
  #   # substituteInPlace CMakeLists.txt \
  #   #   --replace "\''${MODULEPATH}" "$out/''${modulepath#/nix/store/*/}" \
  #   #   --replace "\''${DATAPATH}"   "$out/''${datapath#/nix/store/*/}"

  #   # substituteInPlace CMakeLists.txt \
  #   #   --replace "\''${MODULEPATH}" "$out/qt-5.15.3/plugins" \
  #   #   --replace "\''${DATAPATH}"   "$out/share"
  # '';

  # postConfigure = ''
  #   substituteInPlace cmake_install.cmake \
  #     --replace "${kdelibs4support}" "$out"

  # '';

  meta = with lib; {
    name = "Libre Presenter";
    description = "A church presentation software made with QT/QML";
    homepage = "";
    license = licenses.gpl3;
    maintainers = [ "chriscochrun" ];
    platforms = platforms.all;
  };
}

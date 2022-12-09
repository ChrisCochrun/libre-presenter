# { pkgs ? import <nixpkgs> { } }:
# with pkgs;
{
  stdenv,
  lib,
  # kglobalaccel,
  # kinit,
  # kwin,
  # kio,
  # kguiaddons,
  # kcoreaddons,
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
  karchive,
  kirigami2,
  ki18n,
  kcoreaddons,
  # lightly-qt,
  podofo,
  mpv,
  # Rust tools
  clippy,
  rustc,
  cargo,
  rustfmt,
  rust-analyzer,
  corrosion
}:

stdenv.mkDerivation rec {
  name = "Libre Presenter";
  pname = "libre-presenter";
  version = "0.0.1";

  src = ./.;

  nativeBuildInputs = [
    gcc
    gnumake
    clang
    clang-tools
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
    # gccStdenv
    # stdenv
  ];

  buildInputs = [
    qtbase
    qttools
    qtquickcontrols2
    qtx11extras
    qtmultimedia
    # qtwayland
    kirigami2
    # breeze-icons
    # breeze-qt5
    # qqc2-desktop-style
    karchive
    ki18n
    kcoreaddons
    # lightly-qt
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

  # buildPhase = ''
  # rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/
  # '';

  installPhase = ''
  mkdir -p $out/bin
  cp -r bin/* $out/bin
  rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/
  '';

  RUST_BACKTRACE = 1;
  meta = with lib; {
    name = "Libre Presenter";
    description = "A church presentation software made with QT/QML";
    homepage = "";
    license = licenses.gpl3;
    maintainers = [ "chriscochrun" ];
    platforms = platforms.all;
  };
}

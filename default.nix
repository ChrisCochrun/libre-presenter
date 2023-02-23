# { pkgs ? import <nixpkgs> { } }:
# with pkgs;
{
  stdenv,
  lib,
  gcc,
  gnumake,
  clang,
  cmake,
  extra-cmake-modules,
  pkg-config,
  wrapQtAppsHook,
  makeWrapper,
  qtbase,
  clang-tools,
  qttools,
  qtquickcontrols2,
  qtx11extras,
  qtmultimedia,
  qtwayland,
  karchive,
  kirigami2,
  ki18n,
  kcoreaddons,
  kwindowsystem,
  # kglobalaccel,
  # kinit,
  # kwin,
  # kio,
  # kguiaddons,
  # kcoreaddons,
  podofo,
  mpv,
  ffmpeg_5-full,
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

  __noChroot = true;

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
    rustc
    cargo
    corrosion
    makeWrapper
    # gccStdenv
    # stdenv
  ];

  buildInputs = [
    qtbase
    qttools
    qtquickcontrols2
    qtx11extras
    qtmultimedia
    qtwayland
    kirigami2
    karchive
    ki18n
    kcoreaddons
    kwindowsystem
    podofo
    mpv
    ffmpeg_5-full
    # libsForQt5.kconfig
    # Rust tools
    clippy
    rustfmt
    rust-analyzer
  ];

  RUST_BACKTRACE = 1;
  # preConfigure = ''
  # "${cargo-download}
  # '';

  # postConfigure = ''
  #   substituteInPlace cmake_install.cmake \
  #     --replace "${kdelibs4support}" "$out"

  # '';

  # buildPhase = ''
  # cmake -B build/ -DCMAKE_BUILD_TYPE=Debug
  # make -j8 --dir build/
  # '';

  installPhase = ''
  mkdir -p $out/bin
  cp -r bin/* $out/bin
  rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/
  '';

  meta = with lib; {
    name = "Libre Presenter";
    description = "A church presentation software made with QT/QML";
    homepage = "";
    license = licenses.gpl3;
    maintainers = [ "chriscochrun" ];
    platforms = platforms.all;
  };
}

{ pkgs ? <nixpkgs> { } }:
with pkgs;
mkShell {
  name = "presenter-env";

  nativeBuildInputs = [
    gcc
    gnumake
    clang
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.wrapQtAppsHook
    # gccStdenv
    # stdenv
  ];

  buildInputs = [
    clang-tools
    qt5.full
    qt5.qttools
    qt5.qtquickcontrols2
    qt5.qtx11extras
    qt5.qtmultimedia
    libsForQt5.kirigami2
    # libsForQt5.kirigami-addons
    libsForQt5.ki18n
    libsForQt5.kcoreaddons

    # This is only here because apparently it doesn't pick up the icon theme from the base system
    # papirus-icon-theme
    lightly-qt

    mpv
    # libsForQt5.kconfig
    # ffmpeg-full
    # yt-dlp
  ];
  
  # This creates the proper qt env so that plugins are found right.
  shellHook = ''
    # setQtEnvironment=$(mktemp --suffix .setQtEnvironment.sh)
    # echo "shellHook: setQtEnvironment = $setQtEnvironment"
    # makeWrapper "/bin/sh" "$setQtEnvironment" "''${qtWrapperArgs[@]}"
    # sed "/^exec/d" -i "$setQtEnvironment"
    # source "$setQtEnvironment"
    # export QT_QPA_PLATFORM_PLUGIN_PATH=${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins/platformthemes
    # export QML2_IMPORT_PATH=${libsForQt5.kirigami2}/lib/${builtins.replaceStrings ["full-"] [""] qt5.full.name}/qml
  '';
}

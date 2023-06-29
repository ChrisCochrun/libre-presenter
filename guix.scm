
(define-module (lumina)
  #:use-module (gnu packages)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:))

(define-public corrosion
  (package
    (name "corrosion")
    (version (git-version "0.0.1" revision commit))
    (source (origin ))
    (build-system cmake-build-system)
    (arguments `(#:phases
                 (modify-phases %standard-phases
                   (replace 'build
                     (lambda* (#:key outputs #:allow-other-keys)
                       (invoke "cmake" ""))))))
    (inputs (list
             clang
             clang-toolchain
             qtbase
             qttools
             qtquickcontrols2
             qtx11extras
             qtwayland
             qtwebengine
             kirigami
             qqc2-desktop-style
             karchive
             mpv
             ffmpeg
             rust
             ;; both of these need to be packaged yet
             ;; corrosion is needed for build...
             ;; corrosion
             ;; rust-rustfmt
             rust-clippy
             rust-cargo
             rust-analyzer))
    (license license:gpl3+)
    (home-page "idk")
    (synopsis "A Church Presentation Application")
    (description "idk")
    ))

(define-public lumina
  ;; (let ((commit "62f19dba573b924703829847feb1bfee68885514")
  ;;       (revision "0"))
  (package
    (name "lumina")
    (version (git-version "0.0.1" revision commit))
    (source source)
    (build-system cmake-build-system)
    (arguments `(#:phases
                 (modify-phases %standard-phases
                   (replace 'build
                     (lambda* (#:key outputs #:allow-other-keys)
                       (invoke "cmake" ""))))))
    (inputs (list
             clang
             clang-toolchain
             qtbase
             qttools
             qtquickcontrols2
             qtx11extras
             qtwayland
             qtwebengine
             kirigami
             qqc2-desktop-style
             karchive
             mpv
             ffmpeg
             rust
             ;; both of these need to be packaged yet
             ;; corrosion is needed for build...
             ;; corrosion
             ;; rust-rustfmt
             rust-clippy
             rust-cargo
             rust-analyzer))
    (license license:gpl3+)
    (home-page "idk")
    (synopsis "A Church Presentation Application")
    (description "idk")))

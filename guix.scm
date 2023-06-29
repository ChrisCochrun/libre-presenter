
;; (define-module (lumina)
;;   #:use-module (gnu packages)
;;   #:use-module (gnu packages rust-apps)
;;   #:use-module (gnu packages llvm)
;;   #:use-module (gnu packages qt)
;;   #:use-module (gnu packages kde-frameworks)
;;   #:use-module (gnu packages video)
;;   #:use-module (gnu packages crates-io)
;;   #:use-module (gnu services)
;;   #:use-module (guix gexp)
;;   #:use-module (guix packages)
;;   #:use-module (guix git-download)
;;   #:use-module (guix build-system cmake)
;;   #:use-module ((guix licenses) #:prefix license:))

(use-modules (gnu packages)
             (gnu packages rust-apps)
             (gnu packages llvm)
             (gnu packages qt)
             (gnu packages kde-frameworks)
             (gnu packages video)
             (gnu packages crates-io)
             (gnu services)
             (guix gexp)
             (guix packages)
             (guix git-download)
             (guix build-system cmake)
             ((guix licenses) #:prefix license:))



(define this-directory
  (dirname (local-file-absolute-file-name (local-file "guix.scm"))))

(define source
  (local-file this-directory
              #:recursive? #t
              #:select? (git-predicate this-directory)))

;; (define-public corrosion
;;   (package
;;     (name "corrosion")
;;     (version (git-version "0.0.1" revision commit))
;;     (source (origin ))
;;     (build-system cmake-build-system)
;;     (arguments `(#:phases
;;                  (modify-phases %standard-phases
;;                    (replace 'build
;;                      (lambda* (#:key outputs #:allow-other-keys)
;;                        (invoke "cmake" ""))))))
;;     (inputs (list
;;              clang
;;              clang-toolchain))
;;     (license license:gpl3+)
;;     (home-page "idk")
;;     (synopsis "A Church Presentation Application")
;;     (description "idk")
;;     ))

(define-public lumina
  ;; (let ((commit "62f19dba573b924703829847feb1bfee68885514")
  ;;       (revision "0"))
  (package
    (name "lumina")
    (version "0.0.1")
    (source source)
    (build-system cmake-build-system)
    (arguments `(#:phases
                 (modify-phases %standard-phases
                   (replace 'build
                     (lambda* (#:key outputs #:allow-other-keys)
                       (invoke "sh" "./build.sh" "-d"))))))
    (inputs '(("clang" ,clang)
              ("clang-toolchain" ,clang-toolchain)
              ("qtbase" ,qtbase-5.15.8)
              ("qttools" ,qttools-5.15.8)
              ("qtquickcontrols2" ,qtquickcontrols2-5.15.8)
              ("qtx11extras" ,qtx11extras-5.15.8)
              ("qtwayland" ,qtwayland-5.15.8)
              ("qtwebengine" ,qtwebengine-5.15.8)
              ("kirigami" ,kirigami)
              ("qqc2-desktop-style" ,qqc2-desktop-style)
              ("karchive" ,karchive)
              ("mpv" ,mpv)
              ("ffmpeg" ,ffmpeg-5.1.3)
              ("rust" ,rust)
              ;; both of these need to be packaged yet
              ;; corrosion is needed for build...
              ;; corrosion
              ;; rust-rustfmt
              ("rust-clippy" ,rust-clippy)
              ("rust-cargo" ,rust-cargo)
              ("rust-analyzer" ,rust-analyzer)))
    (license license:gpl3+)
    (home-page "idk")
    (synopsis "A Church Presentation Application")
    (description "idk")))

lumina

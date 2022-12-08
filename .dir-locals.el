;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((projectile-project-compilation-cmd . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
         (compile-command . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
 (c++-mode . ((aggressive-indent-mode . nil))))

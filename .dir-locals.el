;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

<<<<<<< HEAD
((nil . ((projectile-project-compilation-cmd . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
         (compile-command . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
=======
<<<<<<< HEAD
((nil . ((projectile-project-compilation-cmd . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
         (compile-command . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
>>>>>>> c978cf0 (updating)
         (projectile-project-run-cmd . "./bld/bin/presenter")))
=======
((nil . ((projectile-project-compilation-cmd . "cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build/ . && make -j8 --dir build/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
         (compile-command . "cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build/ . && make -j8 --dir build/ && rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/")
         (projectile-project-run-cmd . "./build/bin/presenter")))
>>>>>>> fb671cc (updating)
 (c++-mode . ((aggressive-indent-mode . nil))))

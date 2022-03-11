;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((projectile-project-compilation-cmd . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -B build/ . && make --dir build/")
         (projectile-project-run-cmd . "./build/bin/presenter"))))

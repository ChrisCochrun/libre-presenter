;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((compile-command . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/LibrePresenter/qmlcache/")))
 (prog-mode . ((compile-command . "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -DCMAKE_BUILD_TYPE=Debug -B bld/ . && make -j8 --dir bld/ && rm -rf ~/.cache/librepresenter/LibrePresenter/qmlcache/"))))

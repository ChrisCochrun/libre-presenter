#!/bin/sh

cmake -B bld/ .
make -j8 --dir bld/
rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/

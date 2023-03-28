#!/bin/sh

function build_debug () {
    cmake -B bld/ .
    make -j8 --dir bld/
    rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/
}

function build_release () {
    cmake -DCMAKE_BUILD_TYPE=Release -B bld/ .
    make -j8 --dir bld/
    rm -rf ~/.cache/librepresenter/Libre\ Presenter/qmlcache/
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--debug)
            build_debug
            shift # past value
            ;;
        -r|--release)
            build_release
            shift # past value
            ;;
        *)
            POSITIONAL_ARGS+=("$1") # save positional arg
            shift # past argument
            ;;
    esac
done

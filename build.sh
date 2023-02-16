#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DIR=$1
TARGET=$2

case $TARGET in
    "aarch64-unknown-linux-gnu")
        DL_LOADER="\"/lib/ld-linux-aarch64.so.1\""
        ;;
    "x86_64-unknown-linux-gnu")
        DL_LOADER="\"/lib64/ld-linux-x86-64.so.2\""
        ;;
esac

mkdir -p $DIR

cargo build --target $TARGET

# gcc  -fPIC -pie  -Wl,-E -Iself-executable-dynlib/header -Ltarget/$TARGET/debug self-executable-dynlib/shim.c  -o build/libself_executable_dynlib.so  -lself_executable_dynlib -lpthread -lrt -ldl
gcc -fPIC -shared -DDL_LOADER=$DL_LOADER -Wl,-e,lib_entry -Iself-executable-dynlib/header -o build/libself_executable_dynlib.so -Ltarget/$TARGET/debug self-executable-dynlib/shim.c -lself_executable_dynlib -lpthread -lrt -ldl
gcc -Iself-executable-dynlib/header main_bin/main.c -o build/main_bin -Lbuild  -lself_executable_dynlib

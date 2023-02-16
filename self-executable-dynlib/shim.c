#include <stdio.h>
#include <stdlib.h>
#include "self-executable-dynlib.h"

#ifndef DL_LOADER
#define DL_LOADER "/lib64/ld-linux-x86-64.so.2"
#endif

const char dl_loader[] __attribute__((section(".interp"))) = DL_LOADER;

int lib_entry(int argc, char *argv[]) { 
    _exit(_main());              
}

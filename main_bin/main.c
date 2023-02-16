#include <unistd.h>
#include <sys/wait.h>
#include "self-executable-dynlib.h"

int main(int argc, char **argv) {
    call_me_maybe();

    pid_t child = fork_exec();

    int statloc = 0;
    waitpid(child, &statloc, 0);

    call_me_maybe();

    return 0;
}

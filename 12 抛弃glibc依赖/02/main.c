#include "syscall.h"

int main(int argc, char *argv[])
{
    int a = 0x1234;
    //printf("a:0x%x\n", a);
    write(1, "Hello\n", 6);
    exit(0);
    return 0;
}

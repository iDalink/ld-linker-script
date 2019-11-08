#include <stdio.h>

char bss_var[100];
char glob_var[100] = {0xf5};

int main(int argc, char *argv[])
{
    int a = 0x1234;
    printf("a:0x%x\n", a);
    return 0;
}

#include <stdio.h>
#include "tool.h"

int bss_var;

int glob_var = 0xaa55;

#define printf

int test_case1(void)
{
    int rev;

    rev = math_pow(2, 10);
    printf("2^10=%d\n", rev);
    
    rev = math_add(2, 10);
    printf("2+10=%d\n", rev);

    printf("math_add func len:0x%x\n",
           (unsigned long long)&math_add_end - (unsigned long long)math_add);
    
    printf("math_add=0x%x\n",(unsigned long long)math_add);
    printf("math_add_end=0x%x\n",(unsigned long long)math_add_end);
    return 0;
}

int main(int argc, char *argv[])
{
    //test_case1();
    bss_var = 0x55aa;
    return 0;
}

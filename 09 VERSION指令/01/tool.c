

#if 1
__asm__(".symver math_pow_old, math_pow@@VER_1.1");
__asm__(".symver math_pow_new, math_pow@VER_1.2");
#else
int math_pow(int a, int b)
{
    return 2020;
}
#endif

int math_pow_old(int a, int b)
{
    return 1010;
}


int math_pow_new(int a, int b)
{
    int result = 1;
    int i;
    for (i = 0; i < b; i ++) {
        result *= a;
    }
    return result;
}


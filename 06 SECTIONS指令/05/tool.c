


int math_pow(int a, int b)
{
    int result = 1;
    int i;
    for (i = 0; i < b; i ++) {
        result *= a;
    }
    return result;
}

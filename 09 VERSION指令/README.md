##### 1、符号导出版本

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;符号导出版本在version script中指明.


```

VER_1.1 {
        math_pow;
};


VER_1.2 {
       math_pow;
} VER_1.1;

```


##### 2、函数别名绑定

```
__asm__(".symver math_pow_old, math_pow@@VER_1.1");
__asm__(".symver math_pow_new, math_pow@VER_1.2");
```

##### 三、默认函数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;别名绑定时，两个`@@`符号的表示默认导出版本。一个符号必须导出一个版本。
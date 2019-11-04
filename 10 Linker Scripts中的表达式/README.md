##### 1、常量

```
_fourk_1 = 4K;
_fourk_2 = 4096;
_fourk_3 = 0x1000;
_fourk_4 = 10000o;
```

##### 2、符号名

```
"SECTION" = 9;
"with a space" = "also with a space" + 10;
```

##### 3、运算符

```
precedence      associativity   Operators                Notes
(highest)
1               left            !  -  ~                  (1)
2               left            *  /  %
3               left            +  -
4               left            >>  <<
5               left            ==  !=  >  <  <=  >=
6               left            &
7               left            |
8               left            &&
9               left            ||
10              right           ? :
11              right           &=  +=  -=  *=  /=       (2)
```

##### 4、内建函数

###### 1) ABSOLUTE
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PS: 节内的地址为相对该节起始的地址。
```
SECTIONS {
    . = 0x100;
    .text : {
        *(.text)
        . = 0x1000;
        *(.init)             /*该部分的VMA为0x1100*/
    }
}
```

> ABSOLUTE

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ABSOLUTE把节内相对地址转化为绝对地址。

```
SECTIONS {
    . = 0x100;
    .text : {
        *(.text)
        init_begin = ABSOLUTE(0x1000);
        *(.init)             /*该部分的VMA为0x1100*/
    }
}
```


###### 2) ADDR

> ADDR(section)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;返回指定段的起始地址。

###### 3. ALIGN

> ALIGN(align)
 ALIGN(exp, align)

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;对齐align字节

 ###### 4. LENGTH

 > LENGTH(memory)

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;返回指定region的长度。

 ###### 5. LOADADDR

 > LOADADDR(section)

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;返回LMA地址。

 ###### 6. SIZEOF

 > SIZEOF(section)

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;返回指定段长度。
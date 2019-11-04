##### 1、简单符号值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第一节已经对符号做了描述，并且提及链接脚本也是符号的产生原因之一。符号支持如下运算。


> symbol = expression ;
symbol += expression ;
symbol -= expression ;
symbol *= expression ;
symbol /= expression ;
symbol <<= expression ;
symbol >>= expression ;
symbol &= expression ;
symbol |= expression ;


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第一个用法定义符号，其它用法修改符号值。特殊符号`.`指示当前位置计数器。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本级目录`01`指示了符号的用法。连接脚本和符号表信息如下。

```
ENTRY(main)
INPUT(tool.o tool_base.o)
STARTUP(app.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000;
  .text : { *(.text) }
  . = 0x8000000;
  .data : { *(.data) }
  . = 0xc000000;
  .bss : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该链接脚本指定符号`_bss_end`指向`bss`节的尾部。并且设置`0x20000`字节对齐。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用`readelf`命令查看该符号的记录。可以看到符号的值，并且为全局符号。
```
$ readelf -s app
...
    15: 000000000c020000     0 NOTYPE  GLOBAL DEFAULT    4 _bss_end
...
```

##### 2、局部符号

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;程序为`02`文件夹。链接脚本修改如下。

```
...
HIDDEN(_bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000);
...
```

```
$ readelf -s app
...
    14: 000000000c020000     0 NOTYPE  LOCAL  DEFAULT    4 _bss_end
...
```


##### 3、PROVIDE符号

上述定义&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;的符号不能喝程序中已有的符号重名，如果发生了重名会报告`multi definition`错误。`PROVIDE`可以在程序未定义符号时生成这个符号，如果程序已经定义该符号，则链接脚本不再生成该符号。

##### 4、PROVIDE_HIDDEN符号

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;等同于PROVIDE和HIDDEN的共同属性。


##### 5、C程序访问符号

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C程序访问链接脚本定义的符号十分简单。本例为03目录。定义符号格式如下
```
HIDDEN(_bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000);
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;访问符号方式如下。
```
extern void *_bss_end;
rev = (typeof(rev))(unsigned long)&_bss_end;
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第一章我们描述了汇编指令定义的符号，当时指出符号只有地址意义没有内容意义。这些规则依然适用于链接脚本定义的符号。这里引用手册中的一句话描述其特性。


> Linker scripts symbol declarations, by contrast, create an entry in the symbol table but do not assign any memory to them. Thus they are an address without a value.

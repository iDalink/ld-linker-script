##### 1、指定程序入口

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用ENTRY指令指定程序入口。格式为如下。

> ENTRY(*symbol*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;其它指定入口方式如下。

- 使用命令行-e 参数
- 使用`ENTRY(symbol)`指令
- 平台相关定义，众多平台为start
- .text段的第一个字节
- 地址零

##### 二、包含其它链接脚本

> INCLUDE *filename*

##### 三、指定输入文件

> INPUT (*filename*, *filename*, ...)

> INPUT (*filename* *filename* ...)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果指定`INPUT (-lfile)`形式时，`ld`会转化为`lib*file*.a`形式。


##### 四、输出文件名

> OUTPUT(*filename*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;支持命令行-o 参数设置输出文件名。

##### 五、设置二进制文件搜索路径

> SEARCH_DIR(*path*)

##### 六、设置首个输入文件

> STARTUP(*filename*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;设置文件为第一个输入文件，相当于在命令行指定文件为第一个参数。


##### 七、 测试示例

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试示例为该级目录下的`01`文件夹。`linker script`脚本如下。

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
}
```


##### 八、指定输出文件格式

> OUTPUT_FORMAT(*bfdname*)
> OUTPUT_FORMAT(default, big, little)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`OUTPUT_FORMAT`命令指定输出文件的格式。其用法和命令行的中`--oformat bfdname`参数一致。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;可以通过`objdump -i`命令查看所有的bfd格式。本机的格式输出如下图。

```
BFD header file version (GNU Binutils for Debian) 2.28
elf64-x86-64
 (header little endian, data little endian)
  i386
elf32-i386
 (header little endian, data little endian)
  i386
elf32-iamcu
 (header little endian, data little endian)
  iamcu
elf32-x86-64
 (header little endian, data little endian)
  i386
a.out-i386-linux
 (header little endian, data little endian)
  i386
pei-i386
 (header little endian, data little endian)
  i386
pei-x86-64
 (header little endian, data little endian)
  i386
elf64-l1om
 (header little endian, data little endian)
  l1om
elf64-k1om
 (header little endian, data little endian)
  k1om
elf64-little
 (header little endian, data little endian)
  i386
  l1om
  k1om
  iamcu
  plugin
elf64-big
 (header big endian, data big endian)
  i386
  l1om
  k1om
  iamcu
  plugin
elf32-little
 (header little endian, data little endian)
  i386
  l1om
  k1om
  iamcu
  plugin
elf32-big
 (header big endian, data big endian)
  i386
  l1om
  k1om
  iamcu
  plugin
pe-x86-64
 (header little endian, data little endian)
  i386
pe-bigobj-x86-64
 (header little endian, data little endian)
  i386
pe-i386
 (header little endian, data little endian)
  i386
plugin
 (header little endian, data little endian)
srec
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin
symbolsrec
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin
verilog
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin
tekhex
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin
binary
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin
ihex
 (header endianness unknown, data endianness unknown)
  i386
  l1om
  k1om
  iamcu
  plugin

         elf64-x86-64 elf32-i386 elf32-iamcu elf32-x86-64 a.out-i386-linux 
    i386 elf64-x86-64 elf32-i386 ----------- elf32-x86-64 a.out-i386-linux
    l1om ------------ ---------- ----------- ------------ ----------------
    k1om ------------ ---------- ----------- ------------ ----------------
   iamcu ------------ ---------- elf32-iamcu ------------ ----------------
  plugin ------------ ---------- ----------- ------------ ----------------

         pei-i386 pei-x86-64 elf64-l1om elf64-k1om elf64-little elf64-big 
    i386 pei-i386 pei-x86-64 ---------- ---------- elf64-little elf64-big
    l1om -------- ---------- elf64-l1om ---------- elf64-little elf64-big
    k1om -------- ---------- ---------- elf64-k1om elf64-little elf64-big
   iamcu -------- ---------- ---------- ---------- elf64-little elf64-big
  plugin -------- ---------- ---------- ---------- elf64-little elf64-big

         elf32-little elf32-big pe-x86-64 pe-bigobj-x86-64 pe-i386 plugin srec 
    i386 elf32-little elf32-big pe-x86-64 pe-bigobj-x86-64 pe-i386 ------ srec
    l1om elf32-little elf32-big --------- ---------------- ------- ------ srec
    k1om elf32-little elf32-big --------- ---------------- ------- ------ srec
   iamcu elf32-little elf32-big --------- ---------------- ------- ------ srec
  plugin elf32-little elf32-big --------- ---------------- ------- ------ srec

         symbolsrec verilog tekhex binary ihex 
    i386 symbolsrec verilog tekhex binary ihex
    l1om symbolsrec verilog tekhex binary ihex
    k1om symbolsrec verilog tekhex binary ihex
   iamcu symbolsrec verilog tekhex binary ihex
  plugin symbolsrec verilog tekhex binary ihex

```

##### 九、指定输入文件格式

> TARGET(*bfdname*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该指令影响`INPUT`和`GROUP`指令。等同于命令行`-b bfdname`参数。如果TARGET参数被使用，而`OUTPUT_FORMAT`参数未使用，则输出文件时指定为`TARGET`的最后一个参数。

##### 十、存储别名

> REGION_ALIAS(*alias*, *region*)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;给存储单元`*region*`指定别名`*alias*`。

```
MEMORY
  {
    RAM : ORIGIN = 0, LENGTH = 4M
  }

REGION_ALIAS("REGION_TEXT", RAM);
REGION_ALIAS("REGION_RODATA", RAM);
REGION_ALIAS("REGION_DATA", RAM);
REGION_ALIAS("REGION_BSS", RAM);
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上述例子中，RAM被指定REGION_TEXT、REGION_RODATA、REGION_DATA和REGION_BSS四个别名。


##### 十一、断言

> ASSERT(exp, message)

##### 十二、声明外部符号

> EXTERN(symbol symbol ...)
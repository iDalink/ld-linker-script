##### 1、概述
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Linux编译产出文件种类包括目标文件、可执行文件、动态链接文件、目标归档文件。这些文件格式常为`ELF`格式。

文件类型|英文名|扩展名|生成指令
--|--|--|--
目标文件|object file|.o|gcc -C ...
可执行文件|executable file|————|ld ...
动态链接文件|shared object file|.so|ld -shared ...
目标归档文件|archived file|.a|ar c ...


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;针对一个目标文件，其内容被划分成多个成为`section`的区段，比如记录指令的`.text`段，记录数据的`.data`段。每个区段组成表项，记录在ELF的头部区域。每个表项都记录该段在文件内部的偏移，段被加载的内存地址。


 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当一个程序被连接时，多个文件的`section`会按照一定规则合并成节(`segment`)。程序执行时，系统以节的视角加载该可执行程序。一种特殊情况是，当程序的存储载体是ROM介质，那么程序执行时，需要预先把存储数据的segment拷贝到RAM介质中。还要注意的是，这个RAM介质和ROM介质处于同一个地址空间的下不同地址段中。也就是说，节在存储时会记录两个地址，运行地址称为VMA，存储地址称为LMA。
 
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C函数、变量和汇编的标号在编译时都会转化为符号(`symbol`)。符号的值为该变量的地址。当一个源文件引用外部的符号时，编译产出得到一个未定义的符号，未定义的符号在链接决议时转化为定义的符号，并在指令区域填入正确的符号地址。

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;除了函数和变量，符号还可以来自系统环境信息，比如源程序文件名，也可以来自`linker script`，甚至可以来自汇编源程序。

##### 2、测试用例

 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;下面动手操练下上述概念。创建三个源文件app.c、tool.c和tool.h。编译过程由Makefile管理。请简要浏览Makefile以了解编译过程。这些代码位于01文件夹中。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用 `readelf`查看文件的符号表如下。
``` 
$ readelf -s tool.o

Symbol table '.symtab' contains 9 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS tool.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    2 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     8: 0000000000000000    53 FUNC    GLOBAL DEFAULT    1 math_pow

```
```
$ readelf -s app.o

Symbol table '.symtab' contains 13 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS app.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    7 
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
     9: 0000000000000000    67 FUNC    GLOBAL DEFAULT    1 main
    10: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND _GLOBAL_OFFSET_TABLE_
    11: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND math_pow
    12: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND printf

```
```
$ readelf -s tool_base.o

Symbol table '.symtab' contains 10 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    2 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    9 
     8: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT    1 math_add
     9: 0000000000000007     0 NOTYPE  GLOBAL DEFAULT    1 math_add_end

```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;源程序文件名`tool.c`和`app.c`也成为目标文件的符号，并且类型为FILE。`app.o`记录的外部符号`path_pow`为NOTYPE类型，并且索引类型为UND未决议类型。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我们在汇编程序中定义了`math_add_end`符号。我们该如何认识这个符号？这个符号有值吗？这个符号有地址吗？这个符号的类型是什么？

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`math_add_end`没有长度，即不占用地址空间。所以其没有值概念，但是可以对其取地址，地址即为连接后VMA地址。由于`math_add_end`仅仅记录一个内存位置，所以我们把它声明为void *类型，并在其后的内存位置填入magic数据。app.c中打印了该符号的地址和值。毫无疑问符号地址位于`math_add`后7个字节处，其值为magic值，因为该符号本身没有值，对齐取值会导致内存越界。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日志打印如下。

```
./app
2^10=1024
2+10=12
math_add func len:0x7
math_add=0xd26b47a6
math_add_end=0xf0f0f0f0
```


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`linker script`也可以设置符号。我们会在后续章节中介绍。
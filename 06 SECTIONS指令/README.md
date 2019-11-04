##### 1、指令预览

``` 
*section* [address] [(type)] :
  [AT(lma)]
  [ALIGN(section_align) | ALIGN_WITH_INPUT]
  [SUBALIGN(subsection_align)]
  [constraint]
  {
    output-section-command
    output-section-command
    …
  } [>region] [AT>lma_region] [:phdr :phdr …] [=fillexp] [,]
  ```

##### 2、输出节名

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果节名包含特殊字符，需要使用引号包裹。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;特殊节名`/DISCARD/`会被丢弃。



##### 3、节地址

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;节地址是指该节的VMA地址。如果改地未明确指定，连接器会在考虑严格对齐情况下，首先按照region参数分配内存，其次根据当前位置计数器向下分地址。


```
.text ALIGN(0x10) : { *(.text) }
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.text定位在当前位置对齐16字节空间处。当指定一个section的地址后，当前位置计数器也会同步修改。测试代码位于01目录下。

```

ENTRY(main)
INPUT(tool.o tool_base.o)
STARTUP(app.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000 + 0x100000;
  .text . + 0 : { *(.text) }
  
  . = 0x800000 + 0x10000;
  .data . : { *(.data) }

  . = 0xc00000;
  .bss ALIGN(0x10) * 2 : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}

```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;生成节的描述信息如下。

```
$ make
ld -T linker_script.lds
readelf -l app

Elf file type is EXEC (Executable file)
Entry point 0x810000
There are 4 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000
                 0x0000000000100004 0x0000000000100004  RW     0x200000
  LOAD           0x0000000000210000 0x0000000000810000 0x0000000000810000
                 0x00000000000000e0 0x00000000000000e0  R E    0x200000
  LOAD           0x0000000000400000 0x0000000001800000 0x0000000001800000
                 0x0000000000000000 0x0000000000000004  RW     0x200000
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RWE    0x10

 Section to Segment mapping:
  Segment Sections...
   00     .data 
   01     .text .eh_frame 
   02     .bss 
   03     

```


##### 4、输入文件

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;通配所有文件的指定段。
> *(.text)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;过滤文件。
> EXCLUDE_FILE (*crtend.o *otherfile.o) *(.ctors)
*(EXCLUDE_FILE (*crtend.o *otherfile.o) .ctors)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;增加多个段。这两种写的主要区别在于输入段的顺序不一致。
>*(.text .rdata)
*(.text) *(.rdata)


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;多个输入段时过滤文件。
> *(EXCLUDE_FILE (*somefile.o) .text EXCLUDE_FILE (*somefile.o) .rdata)
> EXCLUDE_FILE (*somefile.o) *(.text .rdata)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;指定文件。
> data.o(.data)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;指定归档内的某个文件。
> archive:file

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;指定归档的所有文件。
> archive:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;指定任何归档内的某一个文件。
> :file

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;一个文件的所有段。
> data.o

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码为02目录。连接脚本如下。该脚本从输入列表中排除汇编程序的编译产出，并把该产出放入单独的段.asm_text内。
```
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000 + 0x1000;
  .text . : EXCLUDE_FILE(tool_base.o)  {*(.text)}
  . = . + 0x1000;
  .asm_text . : {tool_base.o(.text)}
  
  . = . + 0x100000;
  .data . : { *(.data) }

  . = . + 0x200000;
  .bss ALIGN(0x10) * 2 : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}
```

##### 5、gc-sections
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;通过参数，编译器可以把每个函数分配在单独的段中。在程序链接时，不被使用的段将会被丢弃。连接脚背可以通过KEEP指令防止不被引用的段不被丢弃。

> KEEP(SORT_BY_NAME(*)(.ctors)).

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码位于`03`目录下。本测试脚本如下。`test_case1`函数是一个不被引用的段，这里将`.text.*`段使用KEEP标记，那么`test_case1`将会在可执行程序中被保留。即便`.text`没被`KEEP`标记，那么`tool.c`中的函数由于被`test_case1`引用而被保留。

```

ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000 + 0x1000;
  .text . : {*(.text)  KEEP(*(.text.*))}

  . = . + 0x100000;
  .data . : { *(.data) }

  . = . + 0x200000;
  .bss ALIGN(0x10) * 2 : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}
 

```

##### 6、输出数据

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;在节的内部可以使用部分指令插入数据。BYTE, SHORT, LONG和 QUAD 指令 保存 一个, 两个, 四个和八个字节.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`FILL(0x90909090)`填充未指明区域的内存。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码如下图。`.text`使用`FILL`设置填充数据，`. += 0x8`扩大`.text`段8个字节，同时存入`0xff55`标记结尾。`.linker_data`使用数据填充指令填充15个字节的数据。可以使用`xxd`指令输出文件内容进行验证。
```
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000 + 0x1000;
  .text . : {*(.text)  KEEP(*(.text.*)) FILL(0x90909090)
                       . += 0x8;
                       SHORT(0xff55)}


  . = . + 0x10;
  
  .linker_data : {BYTE(0xbb) SHORT(0xaabb) LONG(0xaabbaabb) QUAD(0x1122334455667788)}

  . = . + 0x20000;
  .data . : { *(.data) }


  . = . + 0x200000;
  .bss ALIGN(0x10) * 2 : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}
 
```

##### 7、输出段类型

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;默认情况下，输出段的类型由输入端决定。也可以明确指定段类型。
NOLOAD

- The section should be marked as not loadable, so that it will not be loaded into memory when the program is run. 

DSECT
COPY
INFO
OVERLAY

#### 8、LMA
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;默认LMA地址为VMA，可以使用AT指令指定精确地址，或则使用AT>指令指定内存区域。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码位于05目录。该测试将可执行程序导出为binary文件。请查看LMA对binary文件的大小影响。

##### 9、对齐

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;输出文件对齐
> ALIGN(value)


##### 10、指定输出段存储区域

```
MEMORY { rom : ORIGIN = 0x1000, LENGTH = 0x1000 }
SECTIONS { ROM : { *(.text) } >rom }
```

##### 11、自定义段
```
PHDRS { text PT_LOAD ; }
SECTIONS { .text : { *(.text) } :text }
```
测试示例为06文件夹。

#### 12、填充空隙

```
SECTIONS { .text : { *(.text) } =0x90909090 }
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;该测试可以参照本节的第七小节。


##### 十三、OVERLAY

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;overlay方式可以将多个段定义在同一个内存地址。这种用法主要考虑到部分内存存储速度较快，当执行指定代码时能够将对应的段加载到快速存储从而提高性能。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;overlay的完整格式如下。

```
OVERLAY [start] : [NOCROSSREFS] [AT ( ldaddr )]
  {
    secname1
      {
        output-section-command
        output-section-command
        …
      } [:phdr…] [=fill]
    secname2
      {
        output-section-command
        output-section-command
        …
      } [:phdr…] [=fill]
    …
  } [>region] [:phdr…] [=fill] [,]
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这些段具备相同的起始VMA地址。overlay为每一个段生成`__load_start_secname`和`__load_stop_secname`两个符号。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本小节测试代码位于`07`目录。链接脚本和段格式分布如下。
```
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

PHDRS
{
    text PT_LOAD;
    data PT_LOAD;
    bss PT_LOAD;
}

SECTIONS
{
    OVERLAY 0x400000 : AT(0x1000)
    {
        .text_section{*(.text) *(.text.*)} : text
        .data_section{*(.data)} : data


    }
    .bss_section : {*(.bss)} : bss
}

```
```
$ readelf -l app

Elf file type is EXEC (Executable file)
Entry point 0x400077
There are 3 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000001000 0x0000000000400000 0x0000000000001000
                 0x00000000000000d4 0x00000000000000d4  R E    0x1000
  LOAD           0x0000000000002000 0x0000000000400000 0x0000000000400000
                 0x0000000000000004 0x0000000000000004  RW     0x1000
  LOAD           0x00000000000020d4 0x00000000004000d4 0x00000000004000d4
                 0x0000000000000000 0x0000000000000004  RW     0x1000

 Section to Segment mapping:
  Segment Sections...
   00     .text_section 
   01     .data_section 
   02     .bss 
```
```
$ readelf -s app

Symbol table '.symtab' contains 24 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000400000     0 SECTION LOCAL  DEFAULT    1 
     2: 0000000000400000     0 SECTION LOCAL  DEFAULT    2 
     3: 0000000000000000     0 SECTION LOCAL  DEFAULT    3 
     4: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 
     5: 0000000000000000     0 SECTION LOCAL  DEFAULT    5 
     6: 0000000000000000     0 SECTION LOCAL  DEFAULT    6 
     7: 0000000000000000     0 SECTION LOCAL  DEFAULT    7 
     8: 0000000000000000     0 SECTION LOCAL  DEFAULT    8 
     9: 0000000000000000     0 SECTION LOCAL  DEFAULT    9 
    10: 00000000004000d4     0 SECTION LOCAL  DEFAULT   10 
    11: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS tool.c
    12: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS app.c
    13: 0000000000400004     0 NOTYPE  GLOBAL DEFAULT  ABS __load_stop_data_section
    14: 0000000000400000     0 NOTYPE  GLOBAL DEFAULT  ABS __load_start_data_section
    15: 0000000000001000     0 NOTYPE  GLOBAL DEFAULT  ABS __load_start_text_section
    16: 0000000000400000     4 OBJECT  GLOBAL DEFAULT    2 glob_var
    17: 000000000040003c     0 NOTYPE  GLOBAL DEFAULT    1 math_add_end
    18: 0000000000400000    53 FUNC    GLOBAL DEFAULT    1 math_pow
    19: 00000000004000d4     4 OBJECT  GLOBAL DEFAULT   10 bss_var
    20: 0000000000400035     0 NOTYPE  GLOBAL DEFAULT    1 math_add
    21: 0000000000400044    51 FUNC    GLOBAL DEFAULT    1 test_case1
    22: 0000000000400077    93 FUNC    GLOBAL DEFAULT    1 main
    23: 00000000000010d4     0 NOTYPE  GLOBAL DEFAULT  ABS __load_stop_text_section

```
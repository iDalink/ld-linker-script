##### 1、测试示例
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;这一小节我们演示`linker script`的简单用法。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;第一节中我们创建了一个测试用例，并编译连接出一个能够运行的可执行程序`app`。使用`readelf`命令，获取可执行程序的`segment`分配如下图。

```
 $ readelf -l app  

Elf file type is DYN (Shared object file)
Entry point 0x580
There are 9 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000000040 0x0000000000000040
                 0x00000000000001f8 0x00000000000001f8  R E    0x8
  INTERP         0x0000000000000238 0x0000000000000238 0x0000000000000238
                 0x000000000000001c 0x000000000000001c  R      0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000a04 0x0000000000000a04  R E    0x200000
  LOAD           0x0000000000000dd8 0x0000000000200dd8 0x0000000000200dd8
                 0x0000000000000258 0x0000000000000260  RW     0x200000
  DYNAMIC        0x0000000000000df0 0x0000000000200df0 0x0000000000200df0
                 0x00000000000001e0 0x00000000000001e0  RW     0x8
  NOTE           0x0000000000000254 0x0000000000000254 0x0000000000000254
                 0x0000000000000044 0x0000000000000044  R      0x4
  GNU_EH_FRAME   0x0000000000000890 0x0000000000000890 0x0000000000000890
                 0x0000000000000044 0x0000000000000044  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RWE    0x10
  GNU_RELRO      0x0000000000000dd8 0x0000000000200dd8 0x0000000000200dd8
                 0x0000000000000228 0x0000000000000228  R      0x1

 Section to Segment mapping:
  Segment Sections...
   00     
   01     .interp 
   02     .interp .note.ABI-tag .note.gnu.build-id .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .plt.got .text .fini .rodata .eh_frame_hdr .eh_frame 
   03     .init_array .fini_array .jcr .dynamic .got .got.plt .data .bss 
   04     .dynamic 
   05     .note.ABI-tag .note.gnu.build-id 
   06     .eh_frame_hdr 
   07     
   08     .init_array .fini_array .jcr .dynamic .got 

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;指令节的虚拟地址为`0x0000000000000000`，`.data`和`.bss`保存到同一个节中，虚拟地址为`0x0000000000200dd8`。


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用如下linker script重新编译程序。
```
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
`segments`分配情况如下图。
```
ld -e main -T linker_script.lds -o app app.o tool.o tool_base.o
readelf -l app

Elf file type is EXEC (Executable file)
Entry point 0x400000
There are 4 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  LOAD           0x0000000000200000 0x0000000000400000 0x0000000000400000
                 0x00000000000000e0 0x00000000000000e0  R E    0x200000
  LOAD           0x0000000000400000 0x0000000008000000 0x0000000008000000
                 0x0000000000000004 0x0000000000000004  RW     0x200000
  LOAD           0x0000000000600000 0x000000000c000000 0x000000000c000000
                 0x0000000000000000 0x0000000000000004  RW     0x200000
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RWE    0x10

 Section to Segment mapping:
  Segment Sections...
   00     .text .eh_frame 
   01     .data 
   02     .bss 
   03     
```

##### 2、示例分析
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`.text`节虚拟地址为`0x400000`, `.data`节虚拟地址为`0x8000000`, `.bss`节的虚拟地址为`0xc000000`。
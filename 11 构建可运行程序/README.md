

##### 1、目标
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;你可能已经注意到，我们前面自定义`linker script`编译的可执行均无法正常运行。其原因是现代系统有无数的细节需要小心处理。一方面是，`printf`是系统`libc`提供的函数，为了保证编译通过我们只是简单得把`printf`函数屏蔽，这导致app运行过程中无法输出日志。而且我们为了保证编译简单性，直接将可执行入口指定为`main`函数，而不是常见的`_start`。另外一部分是，程序没有执行`exit`系统调用，这会导致程序无法正常退出，也就是你能在控制台看到程序执行异常。这个异常通常为`segmentation fault`.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本小节我们即解决运行问题。我们的目就是自定义链接脚本，并构建可执行应用程序。接下来的数个小节，即12和13小节，我们会继续探索更多实现方案，这将会更有趣。

##### 2、系统库依赖

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我们先打开标准C库和部分必要的链接。默认`gcc`命令编译产出可执行程序时，会默认指定一组二进制文件。使用`gcc .... -v`命令可以看到完整的编译指令。笔者的计算机上，该指令输出如下。

>  /usr/lib/gcc/x86_64-linux-gnu/6/collect2 -plugin /usr/lib/gcc/x86_64-linux-gnu/6/liblto_plugin.so -plugin-opt=/usr/lib/gcc/x86_64-linux-gnu/6/lto-wrapper -plugin-opt=-fresolution=/tmp/ccFeIZgJ.res -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s -plugin-opt=-pass-through=-lc -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s --sysroot=/ --build-id --eh-frame-hdr -m elf_x86_64 --hash-style=gnu -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -o app /usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu/Scrt1.o /usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/6/crtbeginS.o -L/usr/lib/gcc/x86_64-linux-gnu/6 -L/usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu -L/usr/lib/gcc/x86_64-linux-gnu/6/../../../../lib -L/lib/x86_64-linux-gnu -L/lib/../lib -L/usr/lib/x86_64-linux-gnu -L/usr/lib/../lib -L/usr/lib/gcc/x86_64-linux-gnu/6/../../.. /tmp/ccy30oUZ.o -lgcc --as-needed -lgcc_s --no-as-needed -lc -lgcc --as-needed -lgcc_s --no-as-needed /usr/lib/gcc/x86_64-linux-gnu/6/crtendS.o /usr/lib/gcc/x86_64-linux-gnu/6/../../../x86_64-linux-gnu/crtn.o



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我们先对该命令中的二进制文件做个整理。gcc指定部分参数时，会屏蔽其中部分文件。表格中的x标记表示该参数屏蔽该文件。如果你直接使用ld命令构建应用程序，那么任何默认的二进制文件均不会连接。


文件|包|功能|-nostartfiles|-nostdlib|-nodefaultlibs
-|-|-|-|-|-|-
/usr/lib/x86_64-linux-gnu/Scrt1.o|libc6-dev|_start符号|x|x|
/usr/lib/x86_64-linux-gnu/crti.o|libc6-dev||x|x|
/usr/lib/gcc/x86_64-linux-gnu/6/crtbeginS.o|libgcc-6-dev||x|x|
*loads*|
/usr/lib/gcc/x86_64-linux-gnu/6/libgcc.a|libgcc-6-dev|||x|x
/usr/lib/gcc/x86_64-linux-gnu/6/libgcc_s.so|libgcc-6-dev|||x|x
/usr/lib/x86_64-linux-gnu/libc.so|libc6-dev|||x|x
/usr/lib/gcc/x86_64-linux-gnu/6/crtendS.o |libgcc-6-dev||x|x|
/usr/lib/x86_64-linux-gnu/crtn.o|libc6-dev||x|x|

##### 3、构建可运行程序

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;前面已经分析，由于一个完整的程序依赖这些文件。那么我们只需要按照对应的方式在ld中指定这些文件即可。链接命令如下。

> ld -nostdlib -T linker_script.lds -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o app  -L/usr/lib/gcc/x86_64-linux-gnu/6/ -L /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu/Scrt1.o /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/gcc/x86_64-linux-gnu/6/crtbeginS.o main.o -lgcc -lgcc_s -lc /usr/lib/gcc/x86_64-linux-gnu/6/crtendS.o /usr/lib/x86_64-linux-gnu/crtn.o


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;由于我们的可执行程序包含了动态库依赖，动态库的rela.plt是ld临时生成的段，需要明确保留该段。链接脚本如下。该部分测试代码位于01目录。

```
ENTRY(_start)
SECTIONS
{
    
  . = 0x2000;
  .rela.plt       :
    {
      *(.rela.plt)
    }
  . = 0x1000;
  .text . : { *(.text) }
  
  .data . : { *(.data)}

  .bss : { *(.bss) }
  

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
  __init_array_start = .;
  __init_array_end = .;
  /DISCARD/ : {*(.note.*)}
}
```
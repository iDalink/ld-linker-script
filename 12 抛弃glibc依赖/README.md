##### 1、目标
上一节，我们已经体会到系统库的复杂。为了保持可控性，我们决定抛弃glibc，构建一个完全可控的应用程序。我们需要两个函数，`puts`和`exit`，分别实现日志输出和程序退出。

##### 2、系统调用

应用程序调用系统服务称之为系统调用(`system call`)，应用程序之间的函数调用称之为库调用(`library call`)。x86的系统调用指令为int $0x80。x86-64架构的系统调用指令为syscall，系统调用返回指令为sysret指令。关于该指令的详细细节不再赘述。

下面给出`puts`和`exit`的汇编代码。

```
SYSCALL_NO_WRITE  =  1
SYSCALL_NO_EXIT   = 60

    .text
    .code64
    
    .global write
write:
    mov $SYSCALL_NO_WRITE, %rax
    syscall
    ret
    
    .global exit
exit:
    mov $SYSCALL_NO_EXIT, %rax
    syscall
    ret

```


##### 3、链接

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;为了简单起见，我们首先以静态方式链接系统调用函数。链接命令不再需要指定`glibc`的一串依赖，链接脚本也不再需要指出`plt`段。链接命令和链接脚本如下。测试代码位于01目录。

> ld -static -T linker_script.lds -e main -o app $^

```
ENTRY(_start)
SECTIONS
{
  . = 0;
  .text . : { *(.text) }
  .data . : { *(.data)}
  .bss : { *(.bss) }
}
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;可以看出应用程序的运行时结构十分精简。


#### 4、构建标准库antlibc

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;我们决定将前一小节的两个系统调用函数构造成自己的libc，并把它取名为`antlibc`。理论上来说，只需要将其编译为动态链接库(`so`)即可。方便起见，我们的动态链接库`interpreter`采用glibc提供的`/lib64/ld-linux-x86-64.so.2`。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Makefile文件如下。完整代码位于02目录。该示例编译`syscall.o`为`libantlibc.so`。主程序`app`依赖`libantlibc.so`。

```
test:app
	readelf -l app
	export LD_LIBRARY_PATH=.
	./app

app:main.o libantlibc.so linker_script.lds Makefile
	ld -T linker_script.lds -dynamic-linker /lib64/ld-linux-x86-64.so.2 -L. -e main -o app main.o -lantlibc

main.o:main.c
	gcc -g -c -o $@ $<

libantlibc.so:syscall.o
	ld -shared -o $@ $^
	readelf -l $@

syscall.o:syscall.S
	as -o $@ $<

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;注意，我们的so库位于当前目录下，运行程序时需要将当前目录加入到链接库搜索路径中，命令为`export LD_LIBRARY_PATH=.`。
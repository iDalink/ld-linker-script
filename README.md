
#### 一、什么是ld linker script

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;程序链接时，目标文件根据一系列规则合并成可执行文件。这一步骤同时伴随着复杂的符号重定位、段合并和地址空间分配等步骤。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`ld linker script`是`ld`提供的操作界面，用以对链接过程进行精确把控。使用`ld linker script`可以控制段的合并顺序、地址空间分配和链接符号导出。

#### 二、为什么需要掌握ld linker script

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;涉及`u-boot`和`kernel`开发时，编译产出需要根据硬件环境进行特殊适配。例如，需要把指定指令放入固定存储空间内。甚至编译产出为binary类型文件，对指令和数据的分配都有硬性要求。这些对编译产出的精确控制，都离不开`ld linker script`的帮助。

#### 三、受众群体

`ld linker script`主要面向`bootloader`、`kernel`、`soc`开发人员。这类环境需要对编译产出格式严格控制。另外应用开发仍然有必要了解这门技术，了解空间地址分配其对程序调试仍有裨益。

#### 四、此博客有哪些特性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;毫无疑问地说，`ld linker script`仍然是十分冷门的技术，并且牵涉到大量底层的延伸技术细节。中文资料对这门技术的讲解仍然稀少，只有部分博客上有零零散散的介绍。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此博客立足于现状，对整个技术做个全面介绍。所有章节都以[官方文档(https://sourceware.org/binutils/docs/ld/)](https://sourceware.org/binutils/docs/ld/ "https://sourceware.org/binutils/docs/ld/")为中心，每个章节对应目录都配有演示示例。建议读者仔细阅读示例，多动手尝试实现细节，从而提高掌握水平。

#### 五、我需要掌握哪些技术背景

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;此博客需要读者具备一定的C应用开发经验，对程序的执行加载有所了解。同事要求读者尽可能具备深入的`ELF`技术储备。



---
文章地址：https://github.com/iDalink/ld-linker-script
###<center>章节目录</center>
- *01 基本概念*
- *02 格式*
- *03 简要示例*
- *04 简要链接指令*
- *05 符号值分配*
- *06 SECTIONS指令*
- *07 MEMORY指令*
- *08 PHDRS指令*
- *09 VERSION指令*
- *10 Linker Scripts中的表达式*

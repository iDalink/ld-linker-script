##### 1、完整格式

```
MEMORY
  {
    name [(attr)] : ORIGIN = origin, LENGTH = len
    …
  }
```


####  2、attr

attr|描述
--|--
R | 只读
W | 读写
X | 可执行
A | 可分配
I | 初始
L | 同I
! | 取反

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;示例用法。

```
MEMORY
  {
    rom (rx)  : ORIGIN = 0, LENGTH = 256K
    ram (!rx) : org = 0x40000000, l = 4M
  }
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码参考`01`目录。
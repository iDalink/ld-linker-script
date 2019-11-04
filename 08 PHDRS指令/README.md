##### 1、格式预览

```
PHDRS
{
  name type [ FILEHDR ] [ PHDRS ] [ AT ( address ) ]
        [ FLAGS ( flags ) ] ;
}
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`ld`默认一组`phdrs`。如果自定义了自己的`PHDRS`，那么默认的`phdrs`将会被屏蔽。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`FILEHDR`指明该节包含`ELF`头部。`PHDRS`指明该节包含`ELF`节表。

##### 2、类型

类型 | 描述
--|--
PT_NULL | 未使用节
PT_LOAD | 可加载节
PT_DYNAMIC | 动态链接信息节
PT_INTERP | 动态连接器节
PT_NOTE | 记录信息节
PT_SHLIB | 保留节
PT_PHDR | 节表节
PT_TLS | 线程信息存储节

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;测试代码参见`06`章相关信息。
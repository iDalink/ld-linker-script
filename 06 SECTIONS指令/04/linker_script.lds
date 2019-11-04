
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
 


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

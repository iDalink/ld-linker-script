
ENTRY(main)
INPUT(tool.o tool_base.o)
STARTUP(app.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000;
  .text : { *(.text) }
  . = 0x8000000;
  .data : { *(.data) }
  . = 0xc000000;
  .bss : { *(.bss) }
}

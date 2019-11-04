
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000 + 0x1000;
  .text . : {EXCLUDE_FILE(tool_base.o) *(.text)}
  . = . + 0x1000;
  .asm_text . : {tool_base.o(.text)}

  . = . + 0x100000;
  .data . : { *(.data) }

  . = . + 0x200000;
  .bss ALIGN(0x10) * 2 : { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}
 

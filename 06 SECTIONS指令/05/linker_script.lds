
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

SECTIONS
{
  . = 0x400000;
  .text . : {*(.text)  KEEP(*(.text.*)) FILL(0x90909090)
                       . += 0x8;
                       SHORT(0xff55)}

   _text_end = .;
   . = 0x8000000;
  .data ALIGN(0x10) : AT (_text_end) { *(.data) }
  .bss ALIGN(0x10) : AT (_text_end) { *(.bss) }

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
}
 

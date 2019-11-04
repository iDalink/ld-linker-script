
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

PHDRS
{
    text PT_LOAD;
    gcsection PT_LOAD;
    data PT_LOAD;
    bss PT_LOAD;
}

. = 0x200000;
SECTIONS
{
  . = 0x4000;
  .text . : {*(.text)} : text
  .outer . : {*(.text.*)} : gcsection
   . = 0x8000000;
  .data : { *(.data) } : data
  .bss : { *(.bss) } : bss
}
 

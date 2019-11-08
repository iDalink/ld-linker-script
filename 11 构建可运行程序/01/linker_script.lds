ENTRY(_start)
SECTIONS
{
    
  . = 0x2000;
  .rela.plt       :
    {
      *(.rela.plt)
    }
  . = 0x1000;
  .text . : { *(.text) }
  
  .data . : { *(.data)}

  .bss : { *(.bss) }
  

  _bss_end = (. + 0x20000 - 1) / 0x20000 * 0x20000;
  __init_array_start = .;
  __init_array_end = .;
  /DISCARD/ : {*(.note.*)}
}


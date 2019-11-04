
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

PHDRS
{
    text PT_LOAD;
    data PT_LOAD;
    bss PT_LOAD;
}

MEMORY
{
    rom (RX) : ORIGIN = 0x3fffff, LENGTH = 256K
    ram (WX) : ORIGIN = 0x820000, LENGTH = 32K
}

SECTIONS
{
    .text_section : {*(.text) *(.text.*)} >rom :text
    .data_section : {*(.data)} >ram :data
    .bss_section  : {*(.bss)}  >ram :bss
}

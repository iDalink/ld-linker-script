
ENTRY(main)
INPUT(app.o tool.o tool_base.o)
OUTPUT(app)

PHDRS
{
    text PT_LOAD;
    data PT_LOAD;
    bss PT_LOAD;
}

SECTIONS
{
    OVERLAY 0x400000 : AT(0x1000)
    {
        .text_section{*(.text) *(.text.*)} : text
        .data_section{*(.data)} : data


    }
    .bss_section : {*(.bss)} : bss
}

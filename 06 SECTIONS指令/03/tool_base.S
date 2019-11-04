    .text
    .code64
    .global math_add
    .global math_add_end
math_add:   
    add %rsi,%rdi
    mov %rdi, %rax
    ret
math_add_end = .
    .word 0xf0f0, 0xf0f0, 0xf0f0, 0xf0f0


    
SYSCALL_NO_WRITE  =  1
SYSCALL_NO_EXIT   = 60

    .text
    .code64
    
    .global write
write:
    mov $SYSCALL_NO_WRITE, %rax
    syscall
    ret
    
    .global exit
exit:
    mov $SYSCALL_NO_EXIT, %rax
    syscall
    ret

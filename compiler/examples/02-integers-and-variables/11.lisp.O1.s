        .global begin
start:
        movq $10, %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
epilog:
        popq %rbp
        retq

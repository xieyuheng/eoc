        .global begin
start:
        movq $50, %rax
        subq $8, %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp start
epilog:
        addq $16, %rsp
        popq %rbp
        retq

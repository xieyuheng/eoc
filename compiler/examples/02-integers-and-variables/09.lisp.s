        .global begin
start:
        movq $11, -8(%rbp)
        addq $11, -8(%rbp)
        movq $20, %rax
        addq -8(%rbp), %rax
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

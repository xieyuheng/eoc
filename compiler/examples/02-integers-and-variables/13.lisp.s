        .global begin
start:
        movq $10, -8(%rbp)
        negq -8(%rbp)
        movq $42, -16(%rbp)
        movq -8(%rbp), %rax
        addq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        addq $10, %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp start
start.epilog:
        addq $16, %rsp
        popq %rbp
        retq

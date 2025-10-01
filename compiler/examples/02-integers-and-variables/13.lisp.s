        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        movq $10, -8(%rbp)
        negq -8(%rbp)
        movq $42, -16(%rbp)
        movq -8(%rbp), %rax
        addq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        addq $10, %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

        .global begin
start:
        movq $1, -8(%rbp)
        movq $5, -16(%rbp)
        movq -16(%rbp), %rax
        movq %rax, -24(%rbp)
        movq -16(%rbp), %rax
        addq %rax, -24(%rbp)
        movq -24(%rbp), %rax
        movq %rax, -32(%rbp)
        addq $100, -32(%rbp)
        movq -8(%rbp), %rax
        addq -32(%rbp), %rax
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

        .global begin
start:
        movq $1, -8(%rbp)
        movq $42, -16(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -24(%rbp)
        addq $7, -24(%rbp)
        movq -24(%rbp), %rax
        movq %rax, -32(%rbp)
        movq -24(%rbp), %rax
        movq %rax, -40(%rbp)
        movq -16(%rbp), %rax
        addq %rax, -40(%rbp)
        movq -32(%rbp), %rax
        movq %rax, -48(%rbp)
        negq -48(%rbp)
        movq -40(%rbp), %rax
        addq -48(%rbp), %rax
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

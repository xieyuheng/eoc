        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $32, %rsp
        jmp begin.body
begin.body:
        movq $1, -8(%rbp)
        movq $5, -16(%rbp)
        movq -16(%rbp), %rax
        movq %rax, -24(%rbp)
        movq -8(%rbp), %rax
        addq %rax, -24(%rbp)
        movq -24(%rbp), %rax
        movq %rax, -32(%rbp)
        addq $100, -32(%rbp)
        movq -8(%rbp), %rax
        addq -32(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $32, %rsp
        popq %rbp
        retq

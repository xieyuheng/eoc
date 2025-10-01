        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        movq $4, -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        addq $1, -16(%rbp)
        movq -16(%rbp), %rax
        addq $2, %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

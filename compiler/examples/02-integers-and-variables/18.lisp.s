        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $32, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        addq $1, -16(%rbp)
        movq -16(%rbp), %rax
        movq %rax, -24(%rbp)
        addq $1, -24(%rbp)
        movq -24(%rbp), %rax
        movq %rax, -32(%rbp)
        addq $1, -32(%rbp)
        movq -32(%rbp), %rax
        addq $1, %rax
        jmp begin.epilog
begin.epilog:
        addq $32, %rsp
        popq %rbp
        retq

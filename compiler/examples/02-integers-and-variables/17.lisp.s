        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        addq $1, -16(%rbp)
        movq $1, %rax
        addq -16(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

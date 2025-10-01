        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $24, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, -8(%rbp)
        callq random_dice
        movq %rax, -16(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -24(%rbp)
        movq -16(%rbp), %rax
        addq %rax, -24(%rbp)
        movq -24(%rbp), %rax
        addq $42, %rax
        jmp begin.epilog
begin.epilog:
        addq $24, %rsp
        popq %rbp
        retq

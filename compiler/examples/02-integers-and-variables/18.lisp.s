        .global begin
start:
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

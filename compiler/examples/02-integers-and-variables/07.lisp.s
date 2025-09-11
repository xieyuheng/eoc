        .global begin
start:
        callq random_dice
        movq %rax, -8(%rbp)
        callq random_dice
        movq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        addq -8(%rbp), %rax
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

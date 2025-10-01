        .global begin
start:
        callq random_dice
        movq %rax, -8(%rbp)
        callq random_dice
        movq %rax, -16(%rbp)
        movq -8(%rbp), %rax
        addq -16(%rbp), %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp start
start.epilog:
        addq $16, %rsp
        popq %rbp
        retq

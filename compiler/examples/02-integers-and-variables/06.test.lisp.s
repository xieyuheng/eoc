start:
        callq random_dice, 0
        movq %rax, -8(%rbp)
        movq -8(%rbp), %rax
        negq %rax
        jmp epilog
main:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp start
epilog:
        addq $16, %rsp
        popq %rbp
        retq


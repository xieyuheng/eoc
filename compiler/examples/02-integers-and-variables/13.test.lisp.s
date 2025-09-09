start:
        movq $10, -8(%rbp)
        negq -8(%rbp)
        movq $42, -16(%rbp)
        movq -8(%rbp), %rax
        addq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        addq $10, %rax
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


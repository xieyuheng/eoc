start:
        movq $4, -8(%rbp)
        movq $8, %rax
        addq -8(%rbp), %rax
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


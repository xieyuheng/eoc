        .global main
start:
        movq $4, -8(%rbp)
        addq $5, -8(%rbp)
        movq $3, -16(%rbp)
        movq -8(%rbp), %rax
        addq %rax, -16(%rbp)
        movq $1, -24(%rbp)
        addq $2, -24(%rbp)
        movq -24(%rbp), %rax
        addq -16(%rbp), %rax
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

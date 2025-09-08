start:
    movq $3, -8(%rbp)
    addq $4, -8(%rbp)
    movq $1, -16(%rbp)
    addq $2, -16(%rbp)
    movq -16(%rbp), %rax
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


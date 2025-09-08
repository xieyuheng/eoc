start:
    movq $6, -8(%rbp)
    movq -8(%rbp), %rax
    movq %rax, -16(%rbp)
    movq -16(%rbp), %rax
    movq %rax, -24(%rbp)
    movq -24(%rbp), %rax
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


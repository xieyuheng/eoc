        .global begin
start:
        movq $1, -8(%rbp)
        addq $2, -8(%rbp)
        movq $4, -16(%rbp)
        addq $5, -16(%rbp)
        movq $3, -24(%rbp)
        movq -16(%rbp), %rax
        addq %rax, -24(%rbp)
        movq -8(%rbp), %rax
        addq -24(%rbp), %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $24, %rsp
        jmp start
epilog:
        addq $24, %rsp
        popq %rbp
        retq

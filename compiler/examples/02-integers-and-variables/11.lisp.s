        .global begin
start:
        movq $1, -8(%rbp)
        addq $2, -8(%rbp)
        movq $3, -16(%rbp)
        addq $4, -16(%rbp)
        movq -8(%rbp), %rax
        addq -16(%rbp), %rax
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

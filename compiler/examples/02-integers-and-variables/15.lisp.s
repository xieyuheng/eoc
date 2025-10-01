        .global begin
start:
        movq $4, -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        addq $1, -16(%rbp)
        movq -16(%rbp), %rax
        addq $2, %rax
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

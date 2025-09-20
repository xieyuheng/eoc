        .global begin
start:
        movq $42, -8(%rbp)
        negq -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        movq %rax, -24(%rbp)
        movq -24(%rbp), %rax
        negq %rax
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

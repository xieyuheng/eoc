        .global begin
start:
        movq $20, -8(%rbp)
        movq $22, -16(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -24(%rbp)
        movq -16(%rbp), %rax
        addq %rax, -24(%rbp)
        movq -24(%rbp), %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $24, %rsp
        jmp start
start.epilog:
        addq $24, %rsp
        popq %rbp
        retq

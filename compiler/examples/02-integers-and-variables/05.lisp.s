        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        movq $42, -8(%rbp)
        movq -8(%rbp), %rax
        movq %rax, -16(%rbp)
        movq -16(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

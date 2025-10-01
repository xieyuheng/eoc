        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        movq $32, -8(%rbp)
        movq $10, -16(%rbp)
        movq -16(%rbp), %rax
        addq -8(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

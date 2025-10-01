        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        jmp begin.body
begin.body:
        movq $11, -8(%rbp)
        addq $11, -8(%rbp)
        movq $20, %rax
        addq -8(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbp
        retq

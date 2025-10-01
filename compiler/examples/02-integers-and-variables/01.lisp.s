        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        jmp begin.body
begin.body:
        movq $4, -8(%rbp)
        movq $8, %rax
        addq -8(%rbp), %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbp
        retq

        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $8, %rsp
        jmp begin.body
begin.body:
        movq $1, %rbx
        movq $5, %rcx
        movq %rcx, -16(%rbp)
        addq %rcx, -16(%rbp)
        movq -16(%rbp), %rcx
        addq $100, %rcx
        movq %rbx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $8, %rsp
        jmp begin.body
begin.body:
        movq $1, %rbx
        addq $2, %rbx
        movq $4, -16(%rbp)
        addq $5, -16(%rbp)
        movq $3, %rcx
        addq -16(%rbp), %rcx
        movq %rbx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

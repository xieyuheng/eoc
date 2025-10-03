        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $8, %rsp
        jmp begin.body
begin.body:
        movq $1, %rbx
        movq $42, %rcx
        addq $7, %rbx
        movq %rbx, -16(%rbp)
        addq %rcx, %rbx
        movq -16(%rbp), %rcx
        negq %rcx
        movq %rbx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

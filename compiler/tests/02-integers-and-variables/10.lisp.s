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
        movq $3, %rcx
        addq $4, %rcx
        addq %rcx, %rbx
        movq %rbx, %rax
        addq $5, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

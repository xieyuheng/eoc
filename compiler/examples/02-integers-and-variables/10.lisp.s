        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        addq $2, %rdx
        movq $3, %rcx
        addq $4, %rcx
        addq %rcx, %rdx
        movq %rdx, %rax
        addq $5, %rax
        jmp begin.epilog
begin.epilog:
        addq $16, %rsp
        popq %rbp
        retq

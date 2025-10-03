        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $144, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        addq $2, %rdx
        movq $3, %rcx
        addq $4, %rcx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $144, %rsp
        popq %rbp
        retq

        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $144, %rsp
        jmp begin.body
begin.body:
        movq $10, %rcx
        negq %rcx
        movq $42, %rdx
        addq %rcx, %rdx
        movq %rdx, %rax
        addq $10, %rax
        jmp begin.epilog
begin.epilog:
        addq $144, %rsp
        popq %rbp
        retq

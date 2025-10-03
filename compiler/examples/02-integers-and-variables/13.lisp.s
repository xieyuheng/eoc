        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $128, %rsp
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
        addq $128, %rsp
        popq %rbp
        retq

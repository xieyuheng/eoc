        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
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
        popq %rbp
        retq

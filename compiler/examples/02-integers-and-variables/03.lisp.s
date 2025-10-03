        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $20, %rdx
        movq $22, %rcx
        addq %rcx, %rdx
        movq %rdx, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

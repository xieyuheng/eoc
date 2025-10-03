        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $144, %rsp
        jmp begin.body
begin.body:
        movq $20, %rax
        addq $22, %rax
        jmp begin.epilog
begin.epilog:
        addq $144, %rsp
        popq %rbp
        retq

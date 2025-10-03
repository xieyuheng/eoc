        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $20, %rax
        addq $22, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

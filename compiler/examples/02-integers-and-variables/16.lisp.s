        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $0, %rsp
        jmp begin.body
begin.body:
        movq $50, %rax
        subq $8, %rax
        jmp begin.epilog
begin.epilog:
        addq $0, %rsp
        popq %rbp
        retq

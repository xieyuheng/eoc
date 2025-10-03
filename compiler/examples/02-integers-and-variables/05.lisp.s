        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $128, %rsp
        jmp begin.body
begin.body:
        movq $42, %rcx
        movq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $128, %rsp
        popq %rbp
        retq

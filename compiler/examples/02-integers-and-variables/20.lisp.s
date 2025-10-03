        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $0, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        movq $5, %rcx
        addq %rdx, %rcx
        addq $100, %rcx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $0, %rsp
        popq %rbp
        retq

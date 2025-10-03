        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $144, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        movq $5, %rcx
        movq %rcx, %rsi
        addq %rcx, %rsi
        movq %rsi, %rcx
        addq $100, %rcx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $144, %rsp
        popq %rbp
        retq

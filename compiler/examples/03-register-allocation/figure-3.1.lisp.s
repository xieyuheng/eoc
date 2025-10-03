        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $128, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        movq $42, %rcx
        addq $7, %rdx
        movq %rdx, %rsi
        addq %rcx, %rdx
        movq %rsi, %rcx
        negq %rcx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $128, %rsp
        popq %rbp
        retq

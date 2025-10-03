        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $128, %rsp
        jmp begin.body
begin.body:
        movq $1, %rdx
        addq $2, %rdx
        movq $4, %rsi
        addq $5, %rsi
        movq $3, %rcx
        addq %rsi, %rcx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $128, %rsp
        popq %rbp
        retq

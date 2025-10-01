        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rsp
        pushq %rbp
        pushq %rbx
        pushq %r12
        pushq %r13
        pushq %r14
        pushq %r15
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
        popq %r15
        popq %r14
        popq %r13
        popq %r12
        popq %rbx
        popq %rbp
        popq %rsp
        popq %rbp
        retq

        .global begin
begin.else.1:
        movq %rcx, %rax
        addq $10, %rax
        jmp begin.epilog
begin.then.0:
        movq %rcx, %rax
        addq $2, %rax
        jmp begin.epilog
begin.else.3:
        jmp begin.else.1
begin.then.2:
        jmp begin.then.0
begin.else.5:
        cmpq $2, %rbx
        je begin.then.2
        jmp begin.else.3
begin.then.4:
        cmpq $0, %rbx
        je begin.then.2
        jmp begin.else.3
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $8, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rbx
        callq random_dice
        movq %rax, %rcx
        cmpq $1, %rbx
        jl begin.then.4
        jmp begin.else.5
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

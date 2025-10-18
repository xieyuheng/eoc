        .global begin
begin.let_body.0:
        movq %rcx, %rax
        addq %rbx, %rax
        jmp begin.epilog
begin.else.2:
        movq -16(%rbp), %rbx
        addq $10, %rbx
        jmp begin.let_body.0
begin.then.1:
        movq -16(%rbp), %rbx
        addq $2, %rbx
        jmp begin.let_body.0
begin.else.4:
        jmp begin.else.2
begin.then.3:
        jmp begin.then.1
begin.else.6:
        cmpq $2, %rbx
        je begin.then.3
        jmp begin.else.4
begin.then.5:
        cmpq $0, %rbx
        je begin.then.3
        jmp begin.else.4
begin.let_body.7:
        cmpq $1, %rbx
        jl begin.then.5
        jmp begin.else.6
begin.else.9:
        movq -16(%rbp), %rcx
        addq $10, %rcx
        jmp begin.let_body.7
begin.then.8:
        movq -16(%rbp), %rcx
        addq $2, %rcx
        jmp begin.let_body.7
begin.else.11:
        jmp begin.else.9
begin.then.10:
        jmp begin.then.8
begin.else.13:
        cmpq $2, %rbx
        je begin.then.10
        jmp begin.else.11
begin.then.12:
        cmpq $0, %rbx
        je begin.then.10
        jmp begin.else.11
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
        movq %rax, -16(%rbp)
        cmpq $1, %rbx
        jl begin.then.12
        jmp begin.else.13
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

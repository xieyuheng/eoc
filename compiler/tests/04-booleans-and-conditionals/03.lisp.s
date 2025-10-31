        .global begin
begin.else.1:
        movq $42, %rax
        jmp begin.epilog
begin.then.0:
        movq $0, %rax
        jmp begin.epilog
begin.else.3:
        jmp begin.else.1
begin.then.2:
        jmp begin.then.0
begin.then.4:
        callq random_dice
        movq %rax, %rcx
        cmpq $2, %rcx
        je begin.then.2
        jmp begin.else.3
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        cmpq $1, %rcx
        je begin.then.4
        jmp begin.else.3
begin.epilog:
        popq %rbp
        retq

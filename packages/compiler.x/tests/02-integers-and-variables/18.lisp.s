        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        addq $1, %rcx
        addq $1, %rcx
        addq $1, %rcx
        movq %rcx, %rax
        addq $1, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

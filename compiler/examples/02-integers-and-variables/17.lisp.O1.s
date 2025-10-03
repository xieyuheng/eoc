        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $128, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        movq $2, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $128, %rsp
        popq %rbp
        retq

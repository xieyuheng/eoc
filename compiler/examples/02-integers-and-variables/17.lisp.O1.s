        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        movq $2, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

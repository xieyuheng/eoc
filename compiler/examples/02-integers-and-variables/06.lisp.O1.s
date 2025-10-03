        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        movq %rcx, %rax
        negq %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

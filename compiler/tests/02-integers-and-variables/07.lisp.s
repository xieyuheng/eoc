        .global begin
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
        movq %rbx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

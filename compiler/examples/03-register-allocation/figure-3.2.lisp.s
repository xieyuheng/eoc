        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $128, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rbx
        callq random_dice
        movq %rax, %rcx
        movq %rbx, %rdx
        addq %rcx, %rdx
        movq %rdx, %rax
        addq $42, %rax
        jmp begin.epilog
begin.epilog:
        addq $128, %rsp
        popq %rbx
        popq %rbp
        retq

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
        movq %rax, %rdx
        movq %rbx, %rcx
        addq %rdx, %rcx
        movq $42, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

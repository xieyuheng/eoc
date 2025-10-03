        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $0, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, %rcx
        movq $4, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        addq $0, %rsp
        popq %rbp
        retq

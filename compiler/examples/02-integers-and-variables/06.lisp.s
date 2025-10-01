        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        jmp begin.body
begin.body:
        callq random_dice
        movq %rax, -8(%rbp)
        movq -8(%rbp), %rax
        negq %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbp
        retq

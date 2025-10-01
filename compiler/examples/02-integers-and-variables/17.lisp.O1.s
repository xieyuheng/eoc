        .global begin
start:
        callq random_dice
        movq %rax, -8(%rbp)
        movq $2, %rax
        addq -8(%rbp), %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $8, %rsp
        jmp start
start.epilog:
        addq $8, %rsp
        popq %rbp
        retq

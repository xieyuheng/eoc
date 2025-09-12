        .global begin
start:
        callq random_dice
        movq %rax, -8(%rbp)
        movq $2, %rax
        addq -8(%rbp), %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        subq $16, %rsp
        jmp start
epilog:
        addq $16, %rsp
        popq %rbp
        retq

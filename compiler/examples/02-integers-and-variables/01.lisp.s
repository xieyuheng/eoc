        .global begin
start:
        movq $4, -8(%rbp)
        movq $8, %rax
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

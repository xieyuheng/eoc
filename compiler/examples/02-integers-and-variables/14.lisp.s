        .global begin
start:
        movq $32, -8(%rbp)
        movq $10, -16(%rbp)
        movq -16(%rbp), %rax
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

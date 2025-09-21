        .global begin
start:
        movq $50, %rax
        subq $8, %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
epilog:
        popq %rbp
        retq

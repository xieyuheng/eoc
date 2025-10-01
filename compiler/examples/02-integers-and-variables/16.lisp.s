        .global begin
start:
        movq $50, %rax
        subq $8, %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
start.epilog:
        popq %rbp
        retq

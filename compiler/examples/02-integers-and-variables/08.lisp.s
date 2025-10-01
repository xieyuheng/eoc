        .global begin
start:
        movq $20, %rax
        addq $22, %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
start.epilog:
        popq %rbp
        retq

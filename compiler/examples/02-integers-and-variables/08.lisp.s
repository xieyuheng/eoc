        .global begin
start:
        movq $20, %rax
        addq $22, %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
epilog:
        popq %rbp
        retq

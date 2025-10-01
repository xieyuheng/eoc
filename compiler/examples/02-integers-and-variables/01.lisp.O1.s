        .global begin
start:
        movq $12, %rax
        jmp start.epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
start.epilog:
        popq %rbp
        retq

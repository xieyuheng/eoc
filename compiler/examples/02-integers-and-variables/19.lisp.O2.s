        .global begin
start:
        movq $111, %rax
        jmp epilog
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp start
epilog:
        popq %rbp
        retq

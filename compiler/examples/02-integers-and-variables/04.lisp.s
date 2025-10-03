        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $42, %rcx
        negq %rcx
        movq %rcx, %rax
        negq %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

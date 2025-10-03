        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $32, %rcx
        movq $10, %rdx
        movq %rdx, %rax
        addq %rcx, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

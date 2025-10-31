        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $4, %rcx
        addq $1, %rcx
        movq %rcx, %rax
        addq $2, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $10, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

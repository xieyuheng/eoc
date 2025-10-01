        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $107, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

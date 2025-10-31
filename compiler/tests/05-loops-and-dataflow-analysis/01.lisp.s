        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        jmp begin.body
begin.body:
        movq $1, %rdi
        callq print_int
        callq newline
        movq $2, %rdi
        callq print_int
        callq newline
        movq $3, %rdi
        callq print_int
        callq newline
        movq $666, %rax
        jmp begin.epilog
begin.epilog:
        popq %rbp
        retq

        .global begin
begin:
        pushq %rbp
        movq %rsp, %rbp
        pushq %rbx
        subq $8, %rsp
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
        movq $6, %rbx
        movq $4, %rdi
        callq print_int
        callq newline
        movq $5, %rdi
        callq print_int
        callq newline
        movq $6, %rdi
        callq print_int
        callq newline
        movq %rbx, %rax
        addq %rbx, %rax
        jmp begin.epilog
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

        .global begin
begin.else.1:
        movq $222, %rdi
        callq print_int
        callq newline
        movq $1, %rax
        cmpq $2, %rax
        sete %al
        movzbq %al, %rax
        jmp begin.epilog
begin.then.0:
        movq $111, %rdi
        callq print_int
        callq newline
        movq $1, %rax
        cmpq $2, %rax
        sete %al
        movzbq %al, %rax
        jmp begin.epilog
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
        movq $1, %rax
        cmpq $2, %rax
        je begin.then.0
        jmp begin.else.1
begin.epilog:
        addq $8, %rsp
        popq %rbx
        popq %rbp
        retq

(export
  x86-program? cons-x86-program
  x86-program-with?
  block? cons-block
  instr? general-instr? special-instr?
  callq retq jmp
  arg? var-arg imm-arg reg-arg deref-arg
  reg-name?)

(define-data x86-program?
  (cons-x86-program
   (info anything?)
   (blocks (record? block?))))

(claim x86-program-with?
  (-> (-> anything? bool?) x86-program?
      bool?))

(define (x86-program-with? info-p)
  (lambda (x86-program)
    (info-p (cons-x86-program-info x86-program))))

(define-data block?
  (cons-block
   (info anything?)
   (instrs (list? instr?))))

(define instr?
  (union general-instr?
         special-instr?))

(define general-instr?
  (tau symbol? (list? arg?)))

(define-data special-instr?
  (callq (label symbol?) (arity int-non-negative?))
  retq
  (jmp (label symbol?)))

(define-data arg?
  (var-arg (name symbol?))
  (imm-arg (value int?))
  (reg-arg (name reg-name?))
  (deref-arg (name reg-name?) (offset int?)))

(define reg-name-list
  (list-append '(rsp rbp rax  rbx  rcx  rdx  rsi  rdi)
               '(r8  r9  r10  r11  r12  r13  r14  r15)))

(define reg-name?
  (swap list-member? reg-name-list))

(export
  x86-program? cons-x86-program
  block? cons-block
  instr? general-instr? special-instr?
  callq retq jmp
  arg? var-arg imm-arg reg-arg deref-arg
  reg-name?)

(define-data x86-program?
  (cons-x86-program
   (info anything?)
   (blocks (record? block?))))

(define-data block?
  (cons-block
   (info anything?)
   (instrs (list? instr?))))

(define instr? (union general-instr? special-instr?))

(define general-instr? (tau symbol? (list? arg?)))

(define-data special-instr?
  (callq (label symbol?) (arity int-non-negative?))
  retq
  (jmp (label symbol?)))

(define-data arg?
  (var-arg (name symbol?))
  (imm-arg (value int?))
  (reg-arg (name reg-name?))
  (deref-arg (name reg-name?) (offset int?)))

;; TODO fix reg-name?

;; <reg> ::= rsp | rbp | rax | rbx | rcx | rdx | rsi | rdi
;;         | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15

(define reg-name? symbol?)

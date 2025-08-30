(import-all "index.lisp")

(define-data x86-program?
  (cons-x86-program
   (info info?)
   (blocks (record? block?))))

(define info? anything?)

(define-data block?
  (cons-block
   (info info?)
   (instrs (list? instr?))))

(define instr? (union general-instr? special-instr?))

(define general-instr? (tau op? (list? arg?)))

(define op? symbol?)

(define-data special-instr?
  (callq (label symbol?) (arity int-non-negative?))
  retq
  (jmp (label symbol?)))

(define-data arg?
  (var (name symbol?))
  (imm (value int?))
  (reg (name reg-name?))
  (deref (name reg-name?) (offset int?)))

;; TODO fix reg-name?

;; <reg> ::= rsp | rbp | rax | rbx | rcx | rdx | rsi | rdi
;;         | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15

(define reg-name? symbol?)

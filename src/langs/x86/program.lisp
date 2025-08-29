(import-all "index.lisp")

;; <reg> ::= rsp | rbp | rax | rbx | rcx | rdx | rsi | rdi
;;         | r8 | r9 | r10 | r11 | r12 | r13 | r14 | r15
;; <arg> ::= (Imm <int>)
;;         | (Reg <reg>)
;;         | (Deref <reg> <int>)
;; <instr> ::= (Instr addq (<arg> <arg>))
;;           | (Instr subq (<arg> <arg>))
;;           | (Instr negq (<arg>))
;;           | (Instr movq (<arg> <arg>))
;;           | (Instr pushq (<arg>))
;;           | (Instr popq (<arg>))
;;           | (Callq <label> <int>)
;;           | (Retq)
;;           | (Jmp <label>)
;; <block> ::= (Block <info> (<instr> … ))
;; <x86Int> ::= (X86Program <info> ((<label> . <block>) … ))

(define-data program?
  (cons-program
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

(define reg-name? symbol?)

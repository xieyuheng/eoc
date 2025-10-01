(export
  x86-program? cons-x86-program
  x86-program/info?
  x86-program/block?
  block? cons-block
  block/info?
  block-info
  block-instrs
  instr? general-instr? special-instr?
  callq retq jmp
  operand? var-rand imm-rand reg-rand deref-rand
  location-operand?
  reg-name?)

(define-data x86-program?
  (cons-x86-program
   (info anything?)
   (blocks (record? block?))))

(claim x86-program/info?
  (-> (-> anything? bool?) x86-program?
      bool?))

(define (x86-program/info? info-p x86-program)
  (info-p (cons-x86-program-info x86-program)))

(claim x86-program/block?
  (-> (-> block? bool?) x86-program?
      bool?))

(define (x86-program/block? block-p x86-program)
  (list-all?
   block-p
   (record-values (cons-x86-program-blocks x86-program))))

(define-data block?
  (cons-block
   (info anything?)
   (instrs (list? instr?))))

(define block-info cons-block-info)
(define block-instrs cons-block-instrs)

(claim block/info?
  (-> (-> anything? bool?) block?
      bool?))

(define (block/info? info-p block)
  (info-p (cons-block-info block)))

(define instr?
  (union general-instr?
         special-instr?))

(define general-instr?
  (tau symbol? (list? operand?)))

(define-data special-instr?
  (callq (label symbol?) (arity int-non-negative?))
  retq
  (jmp (label symbol?)))

(define-data operand?
  (var-rand (name symbol?))
  (imm-rand (value int?))
  (reg-rand (name reg-name?))
  (deref-rand (name reg-name?) (offset int?)))

(define location-operand?
  (union var-rand? reg-rand? deref-rand?))

(define reg-name-list
  (list-append '(rsp rbp rax  rbx  rcx  rdx  rsi  rdi)
               '(r8  r9  r10  r11  r12  r13  r14  r15)))

(define (reg-name? x)
  (list-member? x reg-name-list))

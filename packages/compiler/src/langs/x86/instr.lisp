(export
  instr? general-instr? special-instr?
  callq retq jmp jmp-if set-if
  callq? retq? jmp? jmp-if? set-if?
  operand? location-operand?
  var-rand imm-rand reg-rand byte-reg-rand deref-rand
  var-rand? imm-rand? reg-rand? byte-reg-rand? deref-rand?
  condition-code?
  operator-condition-codes
  reg-name?
  byte-reg-name?
  extend-byte-register)

(define instr?
  (union general-instr?
         special-instr?))

(define general-instr?
  (tau symbol? (list? operand?)))

(define-data special-instr?
  (callq (label symbol?) (arity int-non-negative?))
  retq
  (jmp (label symbol?))
  (jmp-if (cc condition-code?) (label symbol?))
  (set-if (cc condition-code?) (dest byte-reg-rand?)))

(define condition-codes '(e l le g ge))
(define condition-code? (swap list-member? condition-codes))

(define operator-condition-codes
  [:eq? 'e
   :lt? 'l
   :gt? 'g
   :lteq? 'le
   :gteq? 'ge])

(define-data operand?
  (var-rand (name symbol?))
  (imm-rand (value int?))
  (reg-rand (name reg-name?))
  (byte-reg-rand (name byte-reg-name?))
  (deref-rand (name reg-name?) (offset int?)))

(define location-operand?
  (union var-rand?
         reg-rand?
         byte-reg-rand?
         deref-rand?))

(define reg-names
  '(rsp rbp rax  rbx  rcx  rdx  rsi  rdi
    r8  r9  r10  r11  r12  r13  r14  r15))

(define reg-name? (swap list-member? reg-names))

(define byte-reg-names
  '(ah al bh bl ch cl dh dl))

(define byte-reg-name? (swap list-member? byte-reg-names))

(define (extend-byte-register operand)
  (match operand
    ((reg-rand 'ah) (reg-rand 'rax))
    ((reg-rand 'al) (reg-rand 'rax))
    ((reg-rand 'bh) (reg-rand 'rbx))
    ((reg-rand 'bl) (reg-rand 'rbx))
    ((reg-rand 'ch) (reg-rand 'rcx))
    ((reg-rand 'cl) (reg-rand 'rcx))
    ((reg-rand 'dh) (reg-rand 'rdx))
    ((reg-rand 'dl) (reg-rand 'rdx))
    (else operand)))

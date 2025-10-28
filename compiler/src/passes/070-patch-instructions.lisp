(import-all "deps")

;; Fix pseudo x86 instructions and remove self moves.

(export patch-instructions)

(claim patch-instructions
  (-> x86-mod? x86-mod?))

(define (patch-instructions x86-mod)
  (match x86-mod
    ((cons-x86-mod info blocks)
     (cons-x86-mod info (record-map-value patch-block blocks)))))

(claim patch-block
  (-> block? block?))

(define (patch-block block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-lift patch-instr instrs)))))

(claim patch-instr
  (-> instr? (list? instr?)))

(define (patch-instr instr)
  (cond ((special-instr? instr) [instr])
        ((general-instr? instr)
         (match instr
           ;; remove self move instruction
           (['movq [self self]] [])
           ;; the second operand of movzbq must be register
           (['movzbq [operand-1 (the (negate reg-rand?) operand-2)]]
            [['movq [operand-2 (reg-rand 'rax)]]
             ['movzbq [operand-1 (reg-rand 'rax)]]])
           ;; the second operand of cmpq must not be an immediate
           (['cmpq [operand-1 (imm-rand value)]]
            [['movq [(imm-rand value) (reg-rand 'rax)]]
             ['cmpq [operand-1 (reg-rand 'rax)]]])
           ;; fix two memory location operands
           ([op [(deref-rand reg-name-1 offset-1)
                 (deref-rand reg-name-2 offset-2)]]
            [['movq [(deref-rand reg-name-1 offset-1) (reg-rand 'rax)]]
             [op [(reg-rand 'rax) (deref-rand reg-name-2 offset-2)]]])
           (else [instr])))))

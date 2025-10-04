(import-all "deps")

(export patch-instructions)

(claim patch-instructions
  (-> x86-program? x86-program?))

(define (patch-instructions x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map/value patch-block blocks)))))

(claim patch-block
  (-> block? block?))

(define (patch-block block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-append-map patch-instr instrs)))))

(claim patch-instr
  (-> instr? (list? instr?)))

(define (patch-instr instr)
  (cond ((special-instr? instr) [instr])
        ((general-instr? instr)
         (match instr
           ;; remove self move instruction
           (['movq [self self]] [])
           ;; fix pseudo x86 instruction with two memory location operands
           ([op [(deref-rand reg-name-1 offset-1)
                 (deref-rand reg-name-2 offset-2)]]
            [['movq [(deref-rand reg-name-1 offset-1) (reg-rand 'rax)]]
             [op [(reg-rand 'rax) (deref-rand reg-name-2 offset-2)]]])
           (else [instr])))))

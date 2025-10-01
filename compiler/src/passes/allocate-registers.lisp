(import-all "deps")

(export allocate-registers)

(claim allocate-registers
  (-> (x86-program/info?
       (tau :ctx (record? type?)))
      (x86-program/info?
       (tau :ctx (record? type?)
            :stack-space int?))))

(define (allocate-registers x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= ctx (record-get 'ctx info))
     (= stack-space (imul 8 (record-length ctx)))
     (cons-x86-program
      (record-put 'stack-space stack-space info)
      (record-map (allocate-registers-block ctx) blocks)))))

(claim allocate-registers-block
  (-> (record? type?) block?
      block?))

(define (allocate-registers-block ctx block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-map (allocate-registers-instr ctx) instrs)))))

(claim allocate-registers-instr
  (-> (record? type?) instr?
      instr?))

(define (allocate-registers-instr ctx instr)
  (if (general-instr? instr)
    (begin
      (= [op rands] instr)
      [op (list-map (allocate-registers-operand ctx) rands)])
    instr))

(claim allocate-registers-operand
  (-> (record? type?) operand?
      operand?))

(define (allocate-registers-operand ctx rand)
  (match rand
    ((var-rand name)
     (= index (list-find-index (equal? name) (record-keys ctx)))
     (= offset (imul -8 (iadd 1 index)))
     (deref-rand 'rbp offset))
    (else rand)))

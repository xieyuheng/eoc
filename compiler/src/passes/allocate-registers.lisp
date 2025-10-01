(import-all "deps")

(export allocate-registers)

(claim allocate-registers
  (-> (x86-program/block?
       (block/info?
        (tau :context (record? type?))))
      x86-program?))

(define (allocate-registers x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (cons-x86-program info (record-map allocate-registers-block blocks)))))

(claim allocate-registers-block (-> block? block?))

(define (allocate-registers-block block)
  (match block
    ((cons-block info instrs)
     (= context (record-get 'context info))
     (cons-block info (list-map (allocate-registers-instr context) instrs)))))

(claim allocate-registers-instr
  (-> (record? type?) instr?
      instr?))

(define (allocate-registers-instr context instr)
  (if (general-instr? instr)
    (begin
      (= [op rands] instr)
      [op (list-map (allocate-registers-operand context) rands)])
    instr))

(claim allocate-registers-operand
  (-> (record? type?) operand?
      operand?))

(define (allocate-registers-operand context rand)
  (match rand
    ((var-rand name)
     (= index (list-find-index (equal? name) (record-keys context)))
     (= offset (imul -8 (iadd 1 index)))
     (deref-rand 'rbp offset))
    (else rand)))

(import-all "deps")

(export allocate-registers)

(claim allocate-registers
  (-> (x86-program/info?
       (tau :context (record? type?)))
      (x86-program/info?
       (tau :context (record? type?)
            :stack-space int?))))

(define (allocate-registers x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= context (record-get 'context info))
     (= stack-space (imul 8 (record-length context)))
     (cons-x86-program
      (record-put 'stack-space stack-space info)
      (record-map (allocate-registers-block context) blocks)))))

(claim allocate-registers-block
  (-> (record? type?) block?
      block?))

(define (allocate-registers-block context block)
  (match block
    ((cons-block info instrs)
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

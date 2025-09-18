(import-all "deps.lisp")

(export assign-homes)

(claim assign-homes
  (-> (x86-program-with-info? (tau :ctx (record? type?)))
      x86-program?))

(define (assign-homes x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= ctx (record-get 'ctx info))
     (= stack-space (calc-stack-space ctx))
     (cons-x86-program
      (record-put 'stack-space stack-space info)
      (record-map (assign-homes-block ctx) blocks)))))

(claim calc-stack-space (-> (record? type?) int?))

(define (calc-stack-space ctx)
  (imul 8 (record-length ctx)))

(claim assign-homes-block
  (-> (record? type?) block?
      block?))

(define (assign-homes-block ctx block)
  (match block
    ((cons-block info instrs)
     (cons-block info (list-map (assign-homes-instr ctx) instrs)))))

(claim assign-homes-instr
  (-> (record? type?) instr?
      instr?))

(define (assign-homes-instr ctx instr)
  (match instr
    ([op args]
     [op (list-map (assign-homes-imm ctx) args)])
    (_ instr)))

(claim assign-homes-imm
  (-> (record? type?) operand?
      operand?))

(define (assign-homes-imm ctx arg)
  (match arg
    ((var-rand name)
     (= index (list-find-index (equal? name) (record-keys ctx)))
     (= offset (imul -8 (iadd 1 index)))
     (deref-rand 'rbp offset))
    (_ arg)))

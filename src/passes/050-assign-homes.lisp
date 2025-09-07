(import-all "deps.lisp")

(export assign-homes)

(claim assign-homes
  (-> (x86-program-with? (tau :ctx (record? type?)))
      x86-program?))

(define (assign-homes x86-program)
  (match x86-program
    ((cons-x86-program info blocks)
     (= ctx (record-get 'ctx info))
     (= stack-space (calc-stack-space ctx))
     (cons-x86-program
      (record-set 'stack-space stack-space info)
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
  (-> (record? type?) arg?
      arg?))

(define (assign-homes-imm ctx arg)
  (match arg
    ((var-arg name)
     (= offset (imul -8 (iadd 1 (record-find-index ctx name))))
     (deref-arg 'rbp offset))
    (_ arg)))

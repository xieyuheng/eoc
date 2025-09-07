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

;; (define (assign-homes-imm i ls)
;;   (match i
;;     [(Reg reg) (Reg reg)]
;;     [(Imm int) (Imm int)]
;;     [(Var v) (Deref 'rbp (* -8 (find-index v (cdr ls))))]
;;     ))

;; (define (find-index v ls)
;;   (cond
;;    ;;[(eq? v (Var-name (car ls))) 1]
;;    [(eq? v (car ls)) 1]
;;    [else (add1 (find-index v (cdr ls)))]
;;    ))

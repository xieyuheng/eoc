(import-all "deps")

(export shrink)

(claim shrink (-> program? program?))

(define (shrink program)
  (match program
    ((cons-program info exp)
     (cons-program info (shrink-exp exp)))))

(claim shrink-exp (-> exp? exp?))

(define (shrink-exp exp)
  (match exp
    ((if-exp condition then else)
     (if-exp (shrink-exp condition)
             (shrink-exp then)
             (shrink-exp else)))
    ((prim-exp 'and [e1 e2])
     (if-exp (shrink-exp e1)
             (shrink-exp e2)
             (bool-exp #f)))
    ((prim-exp 'or [e1 e2])
     (if-exp (shrink-exp e1)
             (bool-exp #t)
             (shrink-exp e2)))
    ((prim-exp op args)
     (prim-exp op (list-map shrink-exp args)))
    ((let-exp name rhs body)
     (let-exp name (shrink-exp rhs) (shrink-exp body)))
    (else exp)))

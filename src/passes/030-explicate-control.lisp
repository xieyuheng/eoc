(import-all "deps.lisp")

(claim explicate-control (-> program? c/c-program?))

(define (explicate-control program)
  (match program
    ((cons-program info body)
     (c/cons-c-program info [:start (explicate-seq body)]))))

(claim explicate-seq (-> exp? c/seq?))

(define (explicate-seq exp)
  (match exp
    ((var-exp name)
     (c/return-seq (c/var-exp name)))
    ((int-exp n)
     (c/return-seq (c/int-exp n)))
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-seq body)))
    ((prim-exp op args)
     (c/return-seq (c/prim-exp op (list-map to-c/exp args))))))

(claim to-c/exp (-> exp? c/exp?))

(define (to-c/exp exp)
  (match exp
    ((var-exp name)
     (c/var-exp name))
    ((int-exp n)
     (c/int-exp n))
    ((prim-exp op args)
     (c/prim-exp op (list-map to-c/exp args)))))

(claim explicate-assign (-> symbol? exp? c/seq? c/seq?))

(define (explicate-assign name rhs seq)
  (match rhs
    ((let-exp name2 rhs2 body)
     (= seq2 (explicate-seq body))
     (explicate-assign name2 rhs2 (seq-append name seq2 seq)))
    (_
     (c/cons-seq (c/assign-stmt (c/var-exp name) (to-c/exp rhs)) seq))))

(claim seq-append (-> symbol? c/seq? c/seq? c/seq?))

(define (seq-append name top-seq bottom-seq)
  (match top-seq
    ((c/return-seq exp)
     (c/cons-seq (c/assign-stmt (c/var-exp name) exp) bottom-seq))
    ((c/cons-seq stmt next-seq)
     (c/cons-seq stmt (seq-append name next-seq bottom-seq)))))

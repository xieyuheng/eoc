(import-all "deps.lisp")
(import "020-remove-complex-operands.lisp" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((cons-program info body)
     (cons-c-program info [:start (explicate-seq body)]))))

(claim explicate-seq (-> atom-operand-exp? seq?))

(define (explicate-seq exp)
  (match exp
    ((var-exp name)
     (return-seq (var-c-exp name)))
    ((int-exp n)
     (return-seq (int-c-exp n)))
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-seq body)))
    ((prim-exp op args)
     (return-seq (prim-c-exp op (list-map to-c-exp args))))))

(claim to-c-exp (-> atom-operand-exp? c-exp?))

(define (to-c-exp exp)
  (match exp
    ((var-exp name)
     (var-c-exp name))
    ((int-exp n)
     (int-c-exp n))
    ((prim-exp op args)
     (prim-c-exp op (list-map to-c-exp args)))))

(claim explicate-assign
  (-> symbol? atom-operand-exp? seq? seq?))

;; The third parameter is called `continuation` because it contains
;; the generated code that should come after the current assignment.

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp name2 rhs2 body)
     (= seq2 (explicate-seq body))
     (explicate-assign name2 rhs2 (seq-append name seq2 continuation)))
    (_
     (cons-seq (assign-stmt (var-c-exp name) (to-c-exp rhs))
               continuation))))

(claim seq-append (-> symbol? seq? seq? seq?))

(define (seq-append name top-seq bottom-seq)
  (match top-seq
    ((return-seq exp)
     (cons-seq (assign-stmt (var-c-exp name) exp) bottom-seq))
    ((cons-seq stmt next-seq)
     (cons-seq stmt (seq-append name next-seq bottom-seq)))))

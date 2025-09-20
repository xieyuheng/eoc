(import-all "deps.lisp")
(import "remove-complex-operands.lisp" atomic-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((@program info body)
     (@c-program info [:start (explicate-seq body)]))))

(claim explicate-seq (-> atomic-operand-exp? seq?))

(define (explicate-seq exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-seq body)))
    (_
     (return-seq (to-c-exp exp)))))

(claim to-c-exp
  (-> (inter atomic-operand-exp? (negate let-exp?))
      c-exp?))

(define (to-c-exp exp)
  (match exp
    ((var-exp name)
     (var-c-exp name))
    ((int-exp n)
     (int-c-exp n))
    ((prim-exp op args)
     (prim-c-exp op (list-map to-c-exp args)))))

(claim explicate-assign
  (-> symbol? atomic-operand-exp? seq? seq?))

;; The third parameter is called `continuation` because it contains
;; the generated code that should come after the current assignment.

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     (explicate-assign
      rhs-name rhs-rhs
      (seq-append name (explicate-seq rhs-body) continuation)))
    (_
     (= stmt (assign-stmt (var-c-exp name) (to-c-exp rhs)))
     (cons-seq stmt continuation))))

(claim seq-append (-> symbol? seq? seq? seq?))

(define (seq-append top-result-name top-seq bottom-seq)
  (match top-seq
    ((return-seq exp)
     (= stmt (assign-stmt (var-c-exp top-result-name) exp))
     (cons-seq stmt bottom-seq))
    ((cons-seq stmt top-next-seq)
     (cons-seq stmt (seq-append top-result-name top-next-seq bottom-seq)))))

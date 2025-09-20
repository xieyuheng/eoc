(import-all "deps.lisp")
(import "remove-complex-operands.lisp" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((@program info body)
     (@c-program info [:start (explicate-tail body)]))))

;; `explicate-tail` -- explicate an exp at tail position.
;;   thus this structural recursion is directed
;;   by the shape of input exp.

(claim explicate-tail (-> atom-operand-exp? seq?))

(define (explicate-tail exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-tail body)))
    (_
     (return-seq (to-c-exp exp)))))

(claim to-c-exp
  (-> (inter atom-operand-exp? (negate let-exp?))
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
  (-> symbol? atom-operand-exp? seq? seq?))

;; The third parameter is called `continuation` because it contains
;; the generated code that should come after the current assignment.

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     ;; `rhs-body` is not at tail position,
     ;; but we temporarily view it as so,
     ;; and call `explicate-tail` on it,
     ;; the result will be prepend to the real continuation.
     (= continuation (prepend-assign name (explicate-tail rhs-body) continuation))
     (explicate-assign rhs-name rhs-rhs continuation))
    (_
     (= stmt (assign-stmt (var-c-exp name) (to-c-exp rhs)))
     (cons-seq stmt continuation))))

(claim prepend-assign (-> symbol? seq? seq? seq?))

(define (prepend-assign top-result-name top-seq bottom-seq)
  (match top-seq
    ((return-seq exp)
     (= stmt (assign-stmt (var-c-exp top-result-name) exp))
     (cons-seq stmt bottom-seq))
    ((cons-seq stmt top-next-seq)
     (cons-seq stmt (prepend-assign top-result-name top-next-seq bottom-seq)))))

(import-all "deps")
(import "020-remove-complex-operands" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((cons-program info body)
     (cons-c-program info [:begin (explicate-tail body)]))))

(claim explicate-tail (-> atom-operand-exp? seq?))

(@comment
  To explicate an exp at tail position.
  thus this structural recursion is directed
  by the shape of input exp.

  >> (explicate-tail
      (let ((x (let ((y (ineg 42))) y))) (ineg x)))
  => [(= y (ineg 42))
      (= x y)
      (return (ineg x))])

(define (explicate-tail exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign name rhs (explicate-tail body)))
    (else
     (return-seq (exp-to-c-exp exp)))))

(claim exp-to-c-exp
  (-> (union atom-exp? (inter prim-exp? atom-operand-exp?))
      c-exp?))

(define (exp-to-c-exp exp)
  (match exp
    ((var-exp name)
     (var-c-exp name))
    ((int-exp value)
     (int-c-exp value))
    ((bool-exp value)
     (bool-c-exp value))
    ((prim-exp op args)
     (prim-c-exp op (list-map exp-to-c-exp args)))))

(claim explicate-assign
  (-> symbol? atom-operand-exp? seq? seq?))

(@comment
  To explicate an assignment by
  accumulating a continuation parameter,
  The third parameter is called "continuation"
  because it contains the generated code that
  should come after the current assignment.

  >> (explicate-assign
      x (let ((y (ineg 42))) y)
      (return (ineg x)))
  => [(= y (ineg 42))
      (= x y)
      (return (ineg x))])

(define (explicate-assign name rhs continuation)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     (= continuation (explicate-assign name rhs-body continuation))
     (explicate-assign rhs-name rhs-rhs continuation))
    (else
     (= stmt (assign-stmt (var-c-exp name) (exp-to-c-exp rhs)))
     (cons-seq stmt continuation))))

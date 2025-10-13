(import-all "deps")
(import "020-remove-complex-operands" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> program? c-program?))

(define (explicate-control program)
  (match program
    ((cons-program info body)
     (= seqs [])
     (= label 'begin)
     (record-put! label (explicate-tail seqs label body) seqs)
     (cons-c-program info seqs))))

(claim explicate-tail
  (-> (record? seq?) symbol? atom-operand-exp?
      seq?))

(@comment
  To explicate an exp at tail position.
  thus this structural recursion is directed
  by the shape of input exp.

  >> (explicate-tail
      (let ((x (let ((y (ineg 42)))
                 y)))
        (ineg x)))
  => [(= y (ineg 42))
      (= x y)
      (return (ineg x))])

(define (explicate-tail seqs label exp)
  (match exp
    ((let-exp name rhs body)
     (explicate-assign
      seqs label
      name rhs (explicate-tail seqs label body)))
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
  (-> (record? seq?) symbol?
      symbol? atom-operand-exp? seq?
      seq?))

(@comment
  To explicate in the context of an assignment.
  This is like CPS because the parameter cont
  contains the generated code that should come
  after the current assignment -- the continuation.

  >> (explicate-assign
      x (let ((y (ineg 42))) y)
      (return (ineg x)))
  => [(= y (ineg 42))
      (= x y)
      (return (ineg x))])

(define (explicate-assign seqs label name rhs cont)
  (match rhs
    ((let-exp rhs-name rhs-rhs rhs-body)
     (= cont (explicate-assign seqs label name rhs-body cont))
     (explicate-assign seqs label rhs-name rhs-rhs cont))
    (else
     (= stmt (assign-stmt (var-c-exp name) (exp-to-c-exp rhs)))
     (cons-seq stmt cont))))

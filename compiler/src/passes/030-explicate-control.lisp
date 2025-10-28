(import-all "deps")
(import "020-remove-complex-operands" atom-operand-exp?)

(export explicate-control)

(claim explicate-control (-> mod? c-mod?))

(define (explicate-control mod)
  (match mod
    ((cons-mod info body)
     (= seqs [])
     (= label 'begin)
     (= seq (explicate-tail seqs label body))
     (cons-c-mod info (record-put label seq seqs)))))

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
      name rhs
      (explicate-tail seqs label body)))
    ((if-exp condition then else)
     (explicate-if
      seqs label
      condition
      (explicate-tail seqs label then)
      (explicate-tail seqs label else)))
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
    ((if-exp condition then else)
     (= let-body-label (generate-label seqs label 'let_body cont))
     (explicate-if
      seqs label
      condition
      (explicate-assign seqs label name then (goto-seq let-body-label))
      (explicate-assign seqs label name else (goto-seq let-body-label))))
    (else
     (= stmt (assign-stmt (var-c-exp name) (exp-to-c-exp rhs)))
     (cons-seq stmt cont))))

(claim generate-label
  (-> (record? seq?) symbol? symbol? seq?
      symbol?))

(define (generate-label seqs label name seq)
  (= id (string-to-symbol (format-sexp (record-length seqs))))
  (= found-label (record-find-key (equal? seq) seqs))
  (cond ((null? found-label)
         (= new-label (symbol-concat [label '. name '. id]))
         (record-put! new-label seq seqs)
         new-label)
        (else
         found-label)))

(claim explicate-if
  (-> (record? seq?) symbol?
      atom-operand-exp? seq? seq?
      seq?))

(@comment
  To explicate in the context of if expression.
  CPS with two continuations for two branches.)

(define (explicate-if seqs label condition then-cont else-cont)
  (match condition
    ((var-exp name)
     (explicate-if
      seqs label
      (prim-exp 'eq? [(var-exp name) (bool-exp #t)])
      then-cont else-cont))
    ((bool-exp value)
     (if value then-cont else-cont))
    ((prim-exp 'not [negated-condition])
     (explicate-if seqs label negated-condition else-cont then-cont))
    ((prim-exp (the cmp-op? op) args)
     (branch-seq (prim-c-exp op (list-map exp-to-c-exp args))
                 (generate-label seqs label 'then then-cont)
                 (generate-label seqs label 'else else-cont)))
    ((let-exp name rhs body)
     (= cont (explicate-if seqs label body then-cont else-cont))
     (explicate-assign seqs label name rhs cont))
    ((if-exp inner-condition then else)
     (= then-cont (goto-seq (generate-label seqs label 'then then-cont)))
     (= else-cont (goto-seq (generate-label seqs label 'else else-cont)))
     (explicate-if
      seqs label
      inner-condition
      (explicate-if seqs label then then-cont else-cont)
      (explicate-if seqs label else then-cont else-cont)))))

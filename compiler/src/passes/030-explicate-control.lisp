(import-all "deps")
(import "020-remove-complex-operands" typed-atom-operand-exp?)

;; Translate s to c with explicit execution order.

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
  (-> (record? seq?) symbol? typed-atom-operand-exp?
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
    ((the-exp type (let-exp name rhs body))
     (explicate-assign
      seqs label
      name rhs
      (explicate-tail seqs label body)))
    ((the-exp type (begin-exp sequence))
     (if (list-empty? sequence)
       (return-seq void-c-exp)
       (explicate-begin
        seqs label
        (list-init sequence)
        (explicate-tail seqs label (list-last sequence)))))
    ((the-exp type (if-exp condition then else))
     (explicate-if
      seqs label
      condition
      (explicate-tail seqs label then)
      (explicate-tail seqs label else)))
    (else
     (return-seq (exp-to-c-exp exp)))))

(claim exp-to-c-exp
  (-> typed-atom-operand-exp?
      c-exp?))

(define (exp-to-c-exp exp)
  (match exp
    ((the-exp type (var-exp name))
     (var-c-exp name))
    ((the-exp type (int-exp value))
     (int-c-exp value))
    ((the-exp type (bool-exp value))
     (bool-c-exp value))
    ((the-exp type void-exp)
     void-c-exp)
    ((the-exp type (prim-exp op args))
     (prim-c-exp op (list-map exp-to-c-exp args)))))

(claim explicate-assign
  (-> (record? seq?) symbol?
      symbol? typed-atom-operand-exp? seq?
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
    ((the-exp type (let-exp rhs-name rhs-rhs rhs-body))
     (= cont (explicate-assign seqs label name rhs-body cont))
     (explicate-assign seqs label rhs-name rhs-rhs cont))
    ((the-exp type (if-exp condition then else))
     (= let-body-label (generate-label seqs label 'let_body cont))
     (explicate-if
      seqs label
      condition
      (explicate-assign seqs label name then (goto-seq let-body-label))
      (explicate-assign seqs label name else (goto-seq let-body-label))))
    ((the-exp type _)
     (= stmt (assign-stmt (var-c-exp name) type (exp-to-c-exp rhs)))
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
      typed-atom-operand-exp? seq? seq?
      seq?))

(@comment
  To explicate in the context of if expression.
  CPS with two continuations for two branches.)

(define (explicate-if seqs label condition then-cont else-cont)
  (match condition
    ((the-exp type (var-exp name))
     (explicate-if
      seqs label
      (prim-exp 'eq? [(var-exp name) (bool-exp #t)])
      then-cont else-cont))
    ((the-exp type (bool-exp value))
     (if value then-cont else-cont))
    ((the-exp type (prim-exp 'not [negated-condition]))
     (explicate-if seqs label negated-condition else-cont then-cont))
    ((the-exp type (prim-exp (the cmp-op? op) args))
     (branch-seq (prim-c-exp op (list-map exp-to-c-exp args))
                 (generate-label seqs label 'then then-cont)
                 (generate-label seqs label 'else else-cont)))
    ((the-exp type (let-exp name rhs body))
     (= cont (explicate-if seqs label body then-cont else-cont))
     (explicate-assign seqs label name rhs cont))
    ((the-exp type (if-exp inner-condition then else))
     (= then-cont (goto-seq (generate-label seqs label 'then then-cont)))
     (= else-cont (goto-seq (generate-label seqs label 'else else-cont)))
     (explicate-if
      seqs label
      inner-condition
      (explicate-if seqs label then then-cont else-cont)
      (explicate-if seqs label else then-cont else-cont)))))

(claim explicate-begin
  (-> (record? seq?) symbol?
      (list? typed-atom-operand-exp?) seq?
      seq?))

(define (explicate-begin seqs label sequence cont)
  (match sequence
    ([] cont)
    ((cons exp rest)
     (= stmt (effect-stmt (exp-to-c-exp exp)))
     (cons-seq stmt (explicate-begin seqs label rest cont)))))

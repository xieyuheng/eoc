(import-all "index.lisp")

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (prim-exp (op op?) (args (list? exp?)))
  (let-exp (name symbol?) (rhs exp?) (body exp?)))

(define op? symbol?)

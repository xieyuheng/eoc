(export
  type? int-t
  type-equal?
  form-type)

(define-data type?
  int-t)

(claim type-equal?
  (-> type? type? bool?))

(define (type-equal? lhs rhs)
  (equal? lhs rhs))

(claim form-type
  (-> type? sexp?))

(define (form-type type)
  (match type
    (int-t 'int-t)))

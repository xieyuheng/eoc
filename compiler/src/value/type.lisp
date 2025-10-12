(export
  type? int-t
  type-equal?)

(define-data type?
  int-t
  bool-t)

(claim type-equal?
  (-> type? type? bool?))

(define (type-equal? lhs rhs)
  (equal? lhs rhs))

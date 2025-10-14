(import-all "deps")

(export
  check-op
  operator-types
  operator-prims)

(claim check-op
  (-> (list? type?) symbol?
      (union type? null?)))

(define (check-op arg-types op)
  ((optional-lift (check-type-entry arg-types))
   (record-get op operator-types)))

(claim check-type-entry
  (-> (list? type?) (tau (list? type?) type?)
      (union type? null?)))

(define (check-type-entry arg-types type-entry)
  (= [expected-arg-types return-type] type-entry)
  (if (equal? expected-arg-types arg-types)
    return-type
    null))

(claim operator-types (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-t int-t] int-t]
   :isub [[int-t int-t] int-t]
   :ineg [[int-t] int-t]
   :random-dice [[] int-t]
   :and [[bool-t bool-t] bool-t]
   :or [[bool-t bool-t] bool-t]
   :not [[bool-t] bool-t]
   ;; eq? is generic
   :lt? [[int-t int-t] bool-t]
   :gt? [[int-t int-t] bool-t]
   :lteq? [[int-t int-t] bool-t]
   :gteq? [[int-t int-t] bool-t]])

(claim operator-prims (record? (*-> value? value?)))

(define operator-prims
  [:iadd iadd
   :isub isub
   :ineg ineg
   :random-dice (lambda () (iadd 1 (random-int 0 5)))
   ;; and is lazy
   ;; or is lazy
   :not not
   :eq? equal?
   :lt? int-less?
   :gt? int-greater?
   :lteq? int-less-equal?
   :gteq? int-greater-equal?])

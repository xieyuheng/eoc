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
  [:iadd [[int-type int-type] int-type]
   :isub [[int-type int-type] int-type]
   :ineg [[int-type] int-type]
   :imul [[int-type int-type] int-type]   
   :random-dice [[] int-type]
   :and [[bool-type bool-type] bool-type]
   :or [[bool-type bool-type] bool-type]
   :not [[bool-type] bool-type]
   ;; eq? is generic
   :lt? [[int-type int-type] bool-type]
   :gt? [[int-type int-type] bool-type]
   :lteq? [[int-type int-type] bool-type]
   :gteq? [[int-type int-type] bool-type]])

(claim operator-prims (record? (*-> value? value?)))

(define operator-prims
  [:iadd iadd
   :isub isub
   :ineg ineg
   :imul imul
   :random-dice (lambda () (iadd 1 (random-int 0 5)))
   ;; and is lazy
   ;; or is lazy
   :not not
   :eq? equal?
   :lt? int-less?
   :gt? int-greater?
   :lteq? int-less-equal?
   :gteq? int-greater-equal?])

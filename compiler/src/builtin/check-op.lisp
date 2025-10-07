(import-all "deps")

(export check-op)

(claim check-op
  (-> symbol? (list? type?)
      (union type? null?)))

(define (check-op op arg-types)
  (match (record-get op operator-types)
    (null null)
    ([expected-arg-types return-type]
     (if (and (equal? (list-length expected-arg-types)
                      (list-length arg-types))
              (list-all? (apply type-equal?)
                         (list-zip expected-arg-types arg-types)))
       return-type
       null))))

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-t int-t] int-t]
   :isub [[int-t int-t] int-t]
   :ineg [[int-t] int-t]
   :random-dice [[] int-t]])

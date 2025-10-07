(import-all "deps")

(export check-op)

(claim check-op
  (-> symbol? (list? type?)
      (union type? null?)))

(define (check-op op arg-types)
  (match (record-get op operator-types)
    (null null)
    (type-entry
     (check-type-entry arg-types type-entry))))

;; (define (check-op op arg-types)
;;   ((optional-lift (check-type-entry arg-types))
;;    (record-get op operator-types)))

(claim check-type-entry
  (-> (list? type?) (tau (list? type?) type?)
      (union type? null?)))

(define (check-type-entry arg-types type-entry)
  (= [expected-arg-types return-type] type-entry)
  (if (equal? expected-arg-types arg-types)
    return-type
    null))

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-t int-t] int-t]
   :isub [[int-t int-t] int-t]
   :ineg [[int-t] int-t]
   :random-dice [[] int-t]])

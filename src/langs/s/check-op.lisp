(import-all "index.lisp")

(export check-op)

(claim check-op
  (-> symbol? (list? type?)
      (union type? null?)))

(define (check-op op arg-types)
  (= op-entry (record-get op operator-types))
  (if (null? op-entry)
    null
    (begin
      (= [expected-arg-types return-type] op-entry)
      (if (list-all?
           (lambda (arg-type-pair)
             (= [expected-arg-type arg-type] arg-type-pair)
             (type-equal? expected-arg-type arg-type))
           (list-zip expected-arg-types arg-types))
        return-type
        null))))

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-t int-t] int-t]
   :isub [[int-t int-t] int-t]
   :ineg [[int-t] int-t]
   :random-dice [[] int-t]])

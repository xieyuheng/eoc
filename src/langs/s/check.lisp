(import-all "index.lisp")

(export check-program)

(claim check-program
  (-> program? program?))

(define (check-program program)
  (match program
    ((cons-program info body)
     (= [body^ body-type] (check-exp body []))
     (unless (type-equal? body-type int-t)
       (exit [:who 'check-program
              :message "expected body-type to be int-t"
              :body body :body-type body-type]))
     (cons-program info body^))))

(claim check-exp
  (-> exp? (record? type?)
      (tau exp? type?)))

(define (check-exp exp ctx)
  (match exp
    ((var-exp name)
     [(var-exp name) (record-get name ctx)])
    ((int-exp value)
     [(int-exp value) int-t])
    ((prim-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (swap check-exp ctx) args)))
     [(prim-exp op args^) (check-op op arg-types exp)])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (check-exp rhs ctx))
     (= [body^ body-type] (check-exp body (record-set name rhs-type ctx)))
     [(let-exp name rhs^ body^) body-type])))

(claim check-op
  (-> symbol? (list? type?) exp?
      type?))

(define (check-op op arg-types exp)
  (= entry (record-get op operator-types))
  (= expected-arg-types (list-first entry))
  (= return-type (list-second entry))
  (list-map-zip
   (lambda (expected-arg-type arg-type)
     (unless (type-equal? expected-arg-type arg-type)
       (exit [:who 'check-op
              :op op :exp exp
              :expected-arg-type expected-arg-type
              :arg-type arg-type])))
   expected-arg-types
   arg-types)
  return-type)

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:+ [[int-t int-t] int-t]
   :- [[int-t int-t] int-t]
   :random-dice [[] int-t]])

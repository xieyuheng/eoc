(import-all "index.lisp")

(export check-program)

(claim check-program
  (-> program? program?))

(define (check-program program)
  (match program
    ((cons-program info body)
     (= [body^ body-type] (check-exp body []))
     (check-type-equal? body body-type int-t)
     (cons-program info body^))))

(claim check-type-equal?
  (-> exp? type? type? void?))

(define (check-type-equal? exp lhs rhs)
  (unless (type-equal? lhs rhs)
    (exit [:who 'check-type-equal?
           :exp exp :lhs lhs :rhs rhs])))

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
     (= [args^ types] (list-unzip (list-map (swap check-exp ctx) args)))
     [(prim-exp op args^) (check-op op types exp)])
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
  (list-map-zip (check-type-equal? exp)
                expected-arg-types
                arg-types)
  return-type)

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:+ [[int-t int-t] int-t]
   :- [[int-t int-t] int-t]
   :random-dice [[] int-t]])

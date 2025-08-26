(import-all "index.lisp")

(define operator-types
  [:+ [[int-t int-t] int-t]
   :- [[int-t int-t] int-t]])

(claim type-equal? (-> type? type? bool?))

(define (type-equal? lhs rhs) (equal? lhs rhs))

(claim check-type-equal? (-> exp? type? type? void?))

(define (check-type-equal? exp lhs rhs)
  (if (type-equal? lhs rhs)
    void
    (exit [:message "(check-type-equal?) fail"
           :exp exp :lhs lhs :rhs rhs])))

(claim check-op (-> op? (list? type?) exp? type?))

(define (check-op op arg-types exp)
  (= entry (record-get op operator-types))
  (= expected-arg-types (list-first entry))
  (= return-type (list-second entry))
  (list-map-zip (check-type-equal? exp)
                expected-arg-types
                arg-types)
  return-type)

;; (claim check-exp (-> exp? ctx? (tau exp? type?)))

(define (check-exp exp ctx)
  (match exp
    ((var-exp name)
     [(var-exp name) (ctx-lookup name ctx)])
    ((int-exp value)
     [(int-exp value) int-t])
    ((prim-exp op args)
     (= [args^ types] (list-unzip (list-map (swap check-exp ctx) args)))
     [(prim-exp op args^) (check-op op types exp)])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (check-exp rhs ctx))
     (= [body^ body-type] (check-exp body (cons-ctx name rhs-type ctx)))
     [(let-exp name rhs^ body^) body-type])))

(claim check-program (-> program? program?))

(define (check-program program)
  (match program
    ((make-program info body)
     (= [body^ body-type] (check-exp body empty-ctx))
     (check-type-equal? body body-type int-t)
     (make-program info body^))))

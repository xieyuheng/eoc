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
     [(var-exp name)
      (record-get name ctx)])
    ((int-exp value)
     [(int-exp value)
      int-t])
    ((prim-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (swap check-exp ctx) args)))
     (= return-type (check-op op arg-types))
     (when (null? return-type)
       (exit [:who 'check-exp
              :message "fail on prim-exp"
              :exp exp :arg-types arg-types]))
     [(prim-exp op args^)
      return-type])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (check-exp rhs ctx))
     (= [body^ body-type] (check-exp body (record-set name rhs-type ctx)))
     [(let-exp name rhs^ body^)
      body-type])))

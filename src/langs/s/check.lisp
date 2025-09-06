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

(import-all "deps")
(import-all "index")

(export check-program)

(claim check-program
  (-> program? program?))

(define (check-program program)
  (match program
    ((cons-program info body)
     (= [body^ body-type] (check-exp [] body))
     (unless (type-equal? body-type int-t)
       (exit [:who 'check-program
              :message "expected body-type to be int-t"
              :body body :body-type body-type]))
     (cons-program info body^))))

(claim check-exp
  (-> (record? type?) exp?
      (tau exp? type?)))

(define (check-exp context exp)
  (match exp
    ((var-exp name)
     [(var-exp name)
      (record-get name context)])
    ((int-exp value)
     [(int-exp value)
      int-t])
    ((prim-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (check-exp context) args)))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'check-exp
              :message "fail on prim-exp"
              :exp exp :arg-types arg-types]))
     [(prim-exp op args^)
      return-type])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (check-exp context rhs))
     (= new-context (record-put name rhs-type context))
     (= [body^ body-type] (check-exp new-context body))
     [(let-exp name rhs^ body^)
      body-type])))

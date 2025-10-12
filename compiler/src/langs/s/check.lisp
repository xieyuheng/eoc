(import-all "deps")
(import-all "index")

(export check-program)

(claim check-program
  (-> program? program?))

(define (check-program program)
  (match program
    ((cons-program info body)
     (= [body^ return-type] (infer-exp [] body))
     ;; result-type not used
     (cons-program info body^))))

(claim infer-exp
  (-> (record? type?) exp?
      (tau exp? type?)))

(define (infer-exp context exp)
  (match exp
    ((var-exp name)
     [(var-exp name)
      (record-get name context)])
    ((int-exp value)
     [(int-exp value)
      int-t])
    ((bool-exp value)
     [(bool-exp value)
      bool-t])
    ((if-exp condition consequent alternative)
     [(bool-exp value)
      bool-t])
    ((prim-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (infer-exp context) args)))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-exp
              :message "fail on prim-exp"
              :exp exp :arg-types arg-types]))
     [(prim-exp op args^)
      return-type])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (infer-exp context rhs))
     (= new-context (record-put name rhs-type context))
     (= [body^ body-type] (infer-exp new-context body))
     [(let-exp name rhs^ body^)
      body-type])))

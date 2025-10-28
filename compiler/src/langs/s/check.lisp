(import-all "deps")
(import-all "index")

(export
  check-mod
  infer-exp
  check-exp)

(claim check-mod (-> mod? mod?))

(define (check-mod mod)
  (match mod
    ((cons-mod info body)
     (= typed-body (infer-exp [] body))
     (cons-mod info typed-body))))

(claim infer-exp (-> (record? type?) exp? typed-exp?))

(define (infer-exp context exp)
  (match exp
    ((the-exp type exp)
     (check-exp context exp type))
    ((var-exp name)
     (the-exp (record-get name context) (var-exp name)))
    ((int-exp value)
     (the-exp int-type (int-exp value)))
    ((bool-exp value)
     (the-exp bool-type (bool-exp value)))
    ((if-exp condition then else)
     (= (the-exp condition-type condition^) (infer-exp context condition))
     (unless (equal? bool-type condition-type)
       (exit [:who 'infer-exp
              :message "fail on if-exp's condition"
              :exp exp
              :condition-type condition-type]))
     (= (the-exp then-type then^) (infer-exp context then))
     (= (the-exp else-type else^) (infer-exp context else))
     (unless (equal? then-type else-type)
       (exit [:who 'infer-exp
              :message "fail on if-exp's then and else"
              :exp exp
              :then-type then-type
              :else-type else-type]))
     (the-exp then-type
              (if-exp (the-exp condition-type condition^)
                      (the-exp then-type then^)
                      (the-exp else-type else^))))
    ((prim-exp 'eq? [lhs rhs])
     (= (the-exp lhs-type lhs^) (infer-exp context lhs))
     (= (the-exp rhs-type rhs^) (infer-exp context rhs))
     (unless (equal? lhs-type rhs-type)
       (exit [:who 'infer-exp
              :message "fail on eq?"
              :exp exp
              :lhs-type lhs-type
              :rhs-type rhs-type]))
     (the-exp bool-type
              (prim-exp 'eq? [(the-exp lhs-type lhs^)
                              (the-exp rhs-type rhs^)])))
    ((prim-exp op args)
     (= typed-args (list-map (infer-exp context) args))
     (= arg-types (list-map the-exp-type typed-args))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-exp
              :message "fail on prim-exp, no return-type for op"
              :op op
              :exp exp
              :arg-types arg-types]))
     (the-exp return-type (prim-exp op typed-args)))
    ((let-exp name rhs body)
     (= (the-exp rhs-type rhs^) (infer-exp context rhs))
     (= new-context (record-put name rhs-type context))
     (= (the-exp body-type body^) (infer-exp new-context body))
     (the-exp body-type
              (let-exp name (the-exp rhs-type rhs^)
                       (the-exp body-type body^))))))

(claim check-exp (-> (record? type?) exp? type? typed-exp?))

(define (check-exp context exp type)
  (= (the-exp inferred-type exp^) (infer-exp context exp))
  (unless (equal? type inferred-type)
    (exit [:who 'check-exp
           :message "given type is not equal to inferred-type"
           :exp exp
           :type type
           :inferred-type inferred-type]))
  (the-exp inferred-type exp^))

(claim check-op
  (-> (list? type?) symbol?
      (union type? null?)))

(define (check-op arg-types op)
  ((optional-lift (check-type-entry arg-types))
   (record-get op operator-types)))

(claim check-type-entry
  (-> (list? type?) (tau (list? type?) type?)
      (union type? null?)))

(define (check-type-entry arg-types type-entry)
  (= [expected-arg-types return-type] type-entry)
  (if (equal? expected-arg-types arg-types)
    return-type
    null))

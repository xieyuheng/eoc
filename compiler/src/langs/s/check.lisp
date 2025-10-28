(import-all "deps")
(import-all "index")

(export check-mod)

(claim check-mod
  (-> mod? mod?))

(define (check-mod mod)
  (match mod
    ((cons-mod info body)
     (= [body^ return-type] (infer-exp [] body))
     ;; result-type not used
     (cons-mod info body^))))

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
    ((if-exp condition then else)
     (= [condition^ condition-type] (infer-exp context condition))
     (unless (equal? bool-t condition-type)
       (exit [:who 'infer-exp
              :message "fail on if-exp's condition"
              :exp exp
              :condition-type condition-type]))
     (= [then^ then-type] (infer-exp context then))
     (= [else^ else-type] (infer-exp context else))
     (unless (equal? then-type else-type)
       (exit [:who 'infer-exp
              :message "fail on if-exp's then and else"
              :exp exp
              :then-type then-type
              :else-type else-type]))
     [(if-exp condition^ then^ else^)
      then-type])
    ((prim-exp 'eq? [lhs rhs])
     (= [lhs^ lhs-type] (infer-exp context lhs))
     (= [rhs^ rhs-type] (infer-exp context rhs))
     (unless (equal? lhs-type rhs-type)
       (exit [:who 'infer-exp
              :message "fail on eq?"
              :exp exp
              :lhs-type lhs-type
              :rhs-type rhs-type]))
     [(prim-exp 'eq? [lhs^ rhs^])
      bool-t])
    ((prim-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (infer-exp context) args)))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-exp
              :message "fail on prim-exp"
              :exp exp
              :arg-types arg-types]))
     [(prim-exp op args^)
      return-type])
    ((let-exp name rhs body)
     (= [rhs^ rhs-type] (infer-exp context rhs))
     (= new-context (record-put name rhs-type context))
     (= [body^ body-type] (infer-exp new-context body))
     [(let-exp name rhs^ body^)
      body-type])))

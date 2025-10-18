(import-all "deps")
(import-all "index")

(export check-c-program)

(claim check-c-program
  (-> c-program?
      (c-program/info?
       (tau :context (record? type?)))))

(define (check-c-program c-program)
  (match c-program
    ((cons-c-program info [:begin seq])
     (= context [])
     (check-seq context seq)
     (cons-c-program
      (record-put 'context context info)
      [:begin seq]))))

(claim check-seq
  (-> (record? type?) seq?
      void?))

(define (check-seq context seq)
  (match seq
    ((cons-seq stmt tail)
     (check-stmt context stmt)
     (check-seq context tail))
    ((return-seq result)
     (= result-type (infer-c-exp context result))
     void)
    ((goto-seq label)
     void)
    ((branch-seq condition then-label else-label)
     (= condition-type (infer-c-exp context condition))
     (unless (equal? bool-t condition-type)
       (exit [:who 'check-seq
              :message "fail on branch"
              :context context
              :seq seq]))
     void)))

(claim check-stmt
  (->  (record? type?) stmt?
       void?))

(define (check-stmt context stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= rhs-type (infer-c-exp context rhs))
     (= found-type (record-get name context))
     (cond ((null? found-type)
            (record-put! name rhs-type context)
            void)
           ((not (equal? rhs-type found-type))
            (exit [:who 'check-stmt
                   :stmt stmt
                   :rhs-type rhs-type
                   :found-type found-type]))))))

(claim infer-c-exp
  (-> (record? type?) c-exp?
      type?))

(define (infer-c-exp context c-exp)
  (match c-exp
    ((var-c-exp name)
     (record-get name context))
    ((int-c-exp value)
     int-t)
    ((bool-c-exp value)
     bool-t)
    ((prim-c-exp 'eq? [lhs rhs])
     (= lhs-type (infer-c-exp context lhs))
     (= rhs-type (infer-c-exp context rhs))
     (unless (equal? lhs-type rhs-type)
       (exit [:who 'infer-c-exp
              :message "fail on eq?"
              :c-exp c-exp
              :lhs-type lhs-type
              :rhs-type rhs-type]))
     bool-t)
    ((prim-c-exp op args)
     (= arg-types (list-map (infer-c-exp context) args))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     return-type)))

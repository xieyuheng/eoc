(import-all "deps")
(import-all "index")

(export check-c-program)

(claim check-c-program
  (-> c-program?
      (c-program/info?
       (tau :contexts (record? (record? type?))))))

(define (check-c-program c-program)
  (match c-program
    ((cons-c-program info seqs)
     (= contexts
        (record-map-value
         (lambda (seq)
           (= context [])
           (= result-type (infer-seq context seq))
           ;; result-type not used
           context)
         seqs))
     (cons-c-program
      (record-put 'contexts contexts info)
      seqs))))

(claim infer-seq
  (-> (record? type?) seq?
      type?))

(define (infer-seq context seq)
  (match seq
    ((return-seq result)
     (= [result^ result-type] (infer-c-exp context result))
     result-type)
    ((cons-seq stmt tail)
     (infer-stmt context stmt)
     (infer-seq context tail))))

(claim infer-stmt
  (->  (record? type?) stmt?
       void?))

(define (infer-stmt context stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= [rhs^ rhs-type] (infer-c-exp context rhs))
     (= found-type (record-get name context))
     (if (null? found-type)
       (begin
         (record-put! name rhs-type context)
         void)
       (unless (equal? rhs-type found-type)
         (exit [:who 'infer-stmt
                :stmt stmt
                :rhs-type rhs-type
                :found-type found-type]))))))

(claim infer-c-exp
  (-> (record? type?) c-exp?
      (tau c-exp? type?)))

(define (infer-c-exp context c-exp)
  (match c-exp
    ((var-c-exp name)
     [(var-c-exp name)
      (record-get name context)])
    ((int-c-exp value)
     [(int-c-exp value)
      int-t])
    ((prim-c-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (infer-c-exp context) args)))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'infer-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     [(prim-c-exp op args^)
      return-type])))

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
           (= result-type (check-seq context seq))
           (unless (type-equal? result-type int-t)
             (exit [:who 'check-c-program
                    :message "expected result-type to be int-t"
                    :seq seq
                    :result-type result-type]))
           context)
         seqs))
     (cons-c-program
      (record-put 'contexts contexts info)
      seqs))))

(claim check-seq
  (-> (record? type?) seq?
      type?))

(define (check-seq context seq)
  (match seq
    ((return-seq result)
     (= [result^ result-type] (check-c-exp context result))
     result-type)
    ((cons-seq stmt tail)
     (check-stmt context stmt)
     (check-seq context tail))))

(claim check-stmt
  (->  (record? type?) stmt?
       void?))

(define (check-stmt context stmt)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= [rhs^ rhs-type] (check-c-exp context rhs))
     (= found-type (record-get name context))
     (if (null? found-type)
       (begin
         (record-put! name rhs-type context)
         void)
       (unless (type-equal? rhs-type found-type)
         (exit [:who 'check-stmt
                :stmt stmt
                :rhs-type rhs-type
                :found-type found-type]))))))

(claim check-c-exp
  (-> (record? type?) c-exp?
      (tau c-exp? type?)))

(define (check-c-exp context c-exp)
  (match c-exp
    ((var-c-exp name)
     [(var-c-exp name)
      (record-get name context)])
    ((int-c-exp value)
     [(int-c-exp value)
      int-t])
    ((prim-c-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (check-c-exp context) args)))
     (= return-type (check-op arg-types op))
     (when (null? return-type)
       (exit [:who 'check-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     [(prim-c-exp op args^)
      return-type])))

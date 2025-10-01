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
        (record-map
         (lambda (seq)
           (= context [])
           (= result-type (check-seq seq context))
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
  (-> seq? (record? type?)
      type?))

(define (check-seq seq context)
  (match seq
    ((return-seq result)
     (= [result^ result-type] (check-c-exp result context))
     result-type)
    ((cons-seq stmt tail)
     (check-stmt stmt context)
     (check-seq tail context))))

(claim check-stmt
  (->  stmt? (record? type?)
       void?))

(define (check-stmt stmt context)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= [rhs^ rhs-type] (check-c-exp rhs context))
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
  (-> c-exp? (record? type?)
      (tau c-exp? type?)))

(define (check-c-exp c-exp context)
  (match c-exp
    ((var-c-exp name)
     [(var-c-exp name)
      (record-get name context)])
    ((int-c-exp value)
     [(int-c-exp value)
      int-t])
    ((prim-c-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (swap check-c-exp context) args)))
     (= return-type (check-op op arg-types))
     (when (null? return-type)
       (exit [:who 'check-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     [(prim-c-exp op args^)
      return-type])))

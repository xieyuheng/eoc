(import-all "deps.lisp")
(import-all "index.lisp")

(export check-c-program)

(claim check-c-program
  (-> c-program?
      (c-program-with? (tau :ctx (record? type?)))))

(define (check-c-program c-program)
  (match c-program
    ((cons-c-program info [:start seq])
     (= ctx [])
     (= result-type (check-seq seq ctx))
     (unless (type-equal? result-type int-t)
       (exit [:who 'check-c-program
              :message "expected result-type to be int-t"
              :seq seq
              :result-type result-type]))
     (cons-c-program (record-put 'ctx ctx info) [:start seq]))))

(claim check-seq
  (-> seq? (record? type?)
      type?))

(define (check-seq seq ctx)
  (match seq
    ((return-seq result)
     (= [result^ result-type] (check-c-exp result ctx))
     result-type)
    ((cons-seq stmt tail)
     (check-stmt stmt ctx)
     (check-seq tail ctx))))

(claim check-stmt
  (->  stmt? (record? type?)
       void?))

(define (check-stmt stmt ctx)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= [rhs^ rhs-type] (check-c-exp rhs ctx))
     (= found-type (record-get name ctx))
     (if (null? found-type)
       (begin
         (record-put! name rhs-type ctx)
         void)
       (unless (type-equal? rhs-type found-type)
         (exit [:who 'check-stmt
                :stmt stmt
                :rhs-type rhs-type
                :found-type found-type]))))))

(claim check-c-exp
  (-> c-exp? (record? type?)
      (tau c-exp? type?)))

(define (check-c-exp c-exp ctx)
  (match c-exp
    ((var-c-exp name)
     [(var-c-exp name)
      (record-get name ctx)])
    ((int-c-exp value)
     [(int-c-exp value)
      int-t])
    ((prim-c-exp op args)
     (= [args^ arg-types] (list-unzip (list-map (swap check-c-exp ctx) args)))
     (= return-type (check-op op arg-types))
     (when (null? return-type)
       (exit [:who 'check-c-exp
              :message "fail on prim-c-exp"
              :c-exp c-exp :arg-types arg-types]))
     [(prim-c-exp op args^)
      return-type])))

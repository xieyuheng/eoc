(import-all "index.lisp")

(export check-c-program)

(claim check-c-program
  (-> c-program? c-program?))

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
     (cons-c-program (record-set :locals-types ctx info) [:start seq]))))

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
     (check-seq stmt ctx))))

(claim check-stmt
  (->  stmt? (record? type?)
       void?))

(define (check-stmt stmt ctx)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (= [rhs^ rhs-type] (check-c-exp rhs ctx))
     (= found-type (record-get name ctx))
     (if (null? found-type)
       (record-set! name rhs-type ctx)
       (unless (type-equal? rhs-type found-type)
         (exit [:who check-stmt
                :stmt stmt
                :rhs-type rhs-type
                :found-type found-type]))))))

(claim check-c-exp
  (-> c-exp? (record? type?)
      (tau c-exp? type?)))

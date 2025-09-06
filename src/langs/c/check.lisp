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
     (cons-c-program (record-set 'locals-types ctx info) [:start seq]))))

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
         (record-set! name rhs-type ctx)
         void)
       (unless (type-equal? rhs-type found-type)
         (exit [:who check-stmt
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
     [(prim-c-exp op args^)
      (check-op op arg-types c-exp)])))

(claim check-op
  (-> symbol? (list? type?) c-exp?
      type?))

(define (check-op op arg-types c-exp)
  (= entry (record-get op operator-types))
  (= expected-arg-types (list-first entry))
  (= return-type (list-second entry))
  (list-map-zip
   (lambda (expected-arg-type arg-type)
     (unless (type-equal? expected-arg-type arg-type)
       (exit [:who 'check-op
              :op op :c-exp c-exp
              :expected-arg-type expected-arg-type
              :arg-type arg-type])))
   expected-arg-types
   arg-types)
  return-type)

(claim operator-types
  (record? (tau (list? type?) type?)))

(define operator-types
  [:iadd [[int-t int-t] int-t]
   :isub [[int-t int-t] int-t]
   :ineg [[int-t] int-t]
   :random-dice [[] int-t]])

(import-all "index.lisp")

(export check-c-program)

(claim check-c-program
  (-> c-program? c-program?))

(define (check-c-program c-program)
  (match c-program
    ((cons-c-program info [:start seq])
     (= ctx [])
     (= t (check-seq seq ctx))
     ;; TODO check t
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

(claim check-c-exp
  (-> c-exp? (record? type?)
      (tau c-exp? type?)))

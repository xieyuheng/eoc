(import-all "index.lisp")

(export check-c-program)

(claim check-c-program
  (-> c-program? c-program?))

(define (check-c-program c-program)
  (match c-program
    ((cons-c-program info [:start seq])
     (= ctx [])
     (= t (check-seq ctx seq))
     ;; check t
     (cons-c-program (record-set :locals-types ctx info) [:start seq]))))

(claim check-seq
  (-> (record? type?) seq? type?))

(define (check-seq ctx seq)
  (match seq
    ((return-seq result)
     (= [result^ result-type] (check-c-exp ctx result))
     result-type)
    ((cons-seq stmt tail)
     (check-stmt ctx stmt)
     (check-seq ctx stmt))))

(claim check-stmt
  (-> (record? type?) stmt? void?))

(claim check-c-exp
  (-> (record? type?) c-exp? (tau c-exp? type?)))

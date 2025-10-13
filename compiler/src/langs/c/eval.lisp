(import-all "deps")
(import-all "index")

(export eval-c-program)

(claim eval-c-program (-> c-program? value?))

(define (eval-c-program c-program)
  (match c-program
    ((cons-c-program info [:begin seq])
     (eval-seq seq []))))

(claim eval-seq
  (-> seq? (record? value?) value?))

(define (eval-seq seq env)
  (match seq
    ((return-seq result)
     (eval-c-exp result env))
    ((cons-seq stmt tail)
     (eval-seq tail (eval-stmt stmt env)))))

(claim eval-stmt
  (-> stmt? (record? value?) (record? value?)))

(define (eval-stmt stmt env)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (record-put name (eval-c-exp rhs env) env))))

(claim eval-c-exp
  (-> c-exp? (record? value?) value?))

(define (eval-c-exp c-exp env)
  (match c-exp
    ((int-c-exp n) n)
    ((var-c-exp name)
     (record-get name env))
    ((prim-c-exp op args)
     (apply (record-get op operator-prims)
       (list-map (swap eval-c-exp env) args)))))

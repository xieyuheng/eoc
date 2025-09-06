(import-all "index.lisp")

(export eval-c-program)

(claim eval-c-program (-> c-program? value?))

(define (eval-c-program c-program)
  (match c-program
    ((cons-c-program info [:start seq])
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
     (record-set name (eval-c-exp rhs env) env))))

(claim eval-c-exp
  (-> c-exp? (record? value?) value?))

(define (eval-c-exp c-exp env)
  (match c-exp
    ((int-c-exp n) n)
    ((var-c-exp name)
     (record-get name env))
    ((prim-c-exp op args)
     (eval-prim op args env))))

(claim eval-prim
  (-> symbol? (list? c-exp-atom?) (record? value?) value?))

(define (eval-prim op args env)
  (match [op args]
    (['iadd [x y]]
     (iadd (eval-c-exp x env) (eval-c-exp y env)))
    (['isub [x y]]
     (isub (eval-c-exp x env) (eval-c-exp y env)))
    (['ineg [x]]
     (ineg (eval-c-exp x env)))
    (['random-dice []]
     (iadd 1 (random-int 0 5)))
    (_
     (exit [:who 'eval-prim
            :message "unknown handled prim c-exp"
            :op op
            :args args]))))

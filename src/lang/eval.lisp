(import-all "index.lisp")

(claim eval-exp (-> exp? env? anything?))

(define (eval-exp exp env)
  (match exp
    ((int-exp n) n)
    ((var-exp name)
     (env-lookup-value name env))
    ((prim-exp op args)
     (eval-prim op args env))
    ((let-exp name rhs body)
     (= new-env (cons-env name (eval-exp rhs env) env))
     (eval-exp body new-env))))

(claim eval-prim (-> symbol? (list? exp?) env? anything?))

(define (eval-prim op args env)
  (match [op args]
    (['+ [x y]]
     (iadd (eval-exp x env) (eval-exp y env)))
    (['+ [x]]
     (eval-exp x env))
    (['- [x y]]
     (isub (eval-exp x env) (eval-exp y env)))
    (['- [x]]
     (isub 0 (eval-exp x env)))
    (_
     (exit "unknown handled prim exp"))))

(import-all "program.lisp")
(import-all "env.lisp")

(claim eval-exp (-> exp? env? anything?))

(define (eval-exp exp env)
  (match exp
    ((int-exp n) n)
    ((var-exp name)
     (env-lookup-value env name))
    ((prim-exp op args)
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
    ((let-exp name rhs body)
     (= new-env (env-set-value env name (eval-exp rhs env)))
     (eval-exp body new-env))))

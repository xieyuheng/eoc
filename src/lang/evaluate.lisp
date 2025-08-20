(import-all "program.lisp")
(import-all "env.lisp")

(claim evaluate-exp (-> exp? env? anything?))

(define (evaluate-exp exp env)
  (match exp
    ((int-exp n) n)
    ((var-exp name)
     (env-lookup-value env name))
    ((prim-exp op args)
     (cond ((equal? op '+)
            (iadd (list-ref args 0) (list-ref args 1)))))
    ((let-exp name rhs body)
     (= new-env (env-set-value env name (evaluate-exp rhs env)))
     (evaluate-exp body new-env))))

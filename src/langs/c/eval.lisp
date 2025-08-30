(import-all "index.lisp")

(claim eval-c-program (-> c-program? value?))

(define (eval-c-program c-program)
  (match c-program
    ((cons-c-program info [:start seq])
     (eval-seq seq empty-env))))

(claim eval-seq (-> seq? env? value?))

(define (eval-seq seq env)
  (match seq
    ((return-seq result)
     (eval-c-exp result env))
    ((cons-seq stmt tail)
     (eval-seq tail (eval-stmt stmt env)))))

(claim eval-stmt (-> stmt? env? env?))

(define (eval-stmt stmt env)
  (match stmt
    ((assign-stmt (var-c-exp name) rhs)
     (cons-env name (eval-c-exp rhs env) env))))

(claim eval-c-exp (-> c-exp? env? value?))

(define (eval-c-exp c-exp env)
  (match c-exp
    ((int-c-exp n) n)
    ((var-c-exp name)
     (env-lookup name env))
    ((prim-c-exp op args)
     (eval-prim op args env))))

(claim eval-prim (-> symbol? (list? c-exp-atom?) env? value?))

(define (eval-prim op args env)
  (match [op args]
    (['+ [x y]]
     (iadd (eval-c-exp x env) (eval-c-exp y env)))
    (['+ [x]]
     (eval-c-exp x env))
    (['- [x y]]
     (isub (eval-c-exp x env) (eval-c-exp y env)))
    (['- [x]]
     (ineg (eval-c-exp x env)))
    (_
     (exit [:who 'eval-prim
            :message "unknown handled prim c-exp"]))))

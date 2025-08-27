(import-all "index.lisp")

(claim eval-program (-> program? value?))

(define (eval-program program)
  (match program
    ((make-program info [['start seq]])
     (eval-seq seq empty-env))))

(claim eval-seq (-> seq? env? value?))

(define (eval-seq seq env)
  (match seq
    ((return-seq result)
     (eval-exp result env))
    ((cons-seq stmt tail)
     (eval-seq tail (eval-stmt stmt env)))))

(claim eval-stmt (-> stmt? env? env?))

(define (eval-stmt stmt env)
  (match stmt
    ((assign-stmt (var-exp name) rhs)
     (cons-env name (eval-exp rhs env) env))))

(claim eval-exp (-> exp? env? value?))

(define (eval-exp exp env)
  (match exp
    ((int-exp n) n)
    ((var-exp name)
     (env-lookup name env))
    ((prim-exp op args)
     (eval-prim op args env))))

(claim eval-prim (-> symbol? (list? atom-exp?) env? value?))

(define (eval-prim op args env)
  (match [op args]
    (['+ [x y]]
     (iadd (eval-exp x env) (eval-exp y env)))
    (['+ [x]]
     (eval-exp x env))
    (['- [x y]]
     (isub (eval-exp x env) (eval-exp y env)))
    (['- [x]]
     (ineg (eval-exp x env)))
    (_
     (exit "unknown handled prim exp"))))

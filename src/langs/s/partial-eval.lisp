(import-all "index.lisp")

(export partial-eval-program)

(claim partial-eval-program (-> program? program?))

(define (partial-eval-program program)
  (match program
    ((cons-program info exp)
     (cons-program info (partial-eval-exp exp [])))))

(claim partial-eval-exp
  (-> exp? (record? exp?) exp?))

(define (partial-eval-exp exp env)
  (match exp
    ((var-exp name)
     (= found (record-get name env))
     (if (null? found)
       (var-exp name)
       found))
    ((int-exp n)
     (int-exp n))
    ((prim-exp 'show [e])
     (prim-exp 'show [e]))
    ((prim-exp '+ [e])
     (partial-eval-exp e env))
    ((prim-exp '- [e])
     (partial-eval-neg
      (partial-eval-exp e env)))
    ((prim-exp '+ [e1 e2])
     (partial-eval-add
      (partial-eval-exp e1 env)
      (partial-eval-exp e2 env)))
    ((prim-exp '- [e1 e2])
     (partial-eval-sub
      (partial-eval-exp e1 env)
      (partial-eval-exp e2 env)))
    ((let-exp name rhs body)
     (= new-env (record-set name (partial-eval-exp rhs env) env))
     (partial-eval-exp body new-env))))

(define (partial-eval-neg r)
  (match r
    ((int-exp n)
     (int-exp (ineg n)))
    (_
     (prim-exp '- [r]))))

(define (partial-eval-add r1 r2)
  (match [r1 r2]
    ([(int-exp n1) (int-exp n2)]
     (int-exp (iadd n1 n2)))
    (_
     (prim-exp '+ [r1 r2]))))

(define (partial-eval-sub r1 r2)
  (match [r1 r2]
    ([(int-exp n1) (int-exp n2)]
     (int-exp (isub n1 n2)))
    (_
     (prim-exp '- [r1 r2]))))

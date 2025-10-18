(import-all "deps")

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
    ((bool-exp n)
     (bool-exp n))
    ((if-exp condition consequent alternative)
     (if-exp (partial-eval-exp condition env)
             (partial-eval-exp consequent env)
             (partial-eval-exp alternative env)))
    ((prim-exp 'random-dice [])
     (prim-exp 'random-dice []))
    ((prim-exp 'ineg [e])
     (partial-eval-ineg
      (partial-eval-exp e env)))
    ((prim-exp 'iadd [e1 e2])
     (partial-eval-iadd
      (partial-eval-exp e1 env)
      (partial-eval-exp e2 env)))
    ((prim-exp 'isub [e1 e2])
     (partial-eval-isub
      (partial-eval-exp e1 env)
      (partial-eval-exp e2 env)))
    ((prim-exp op args)
     (prim-exp op (list-map (swap partial-eval-exp env) args)))
    ((let-exp name rhs body)
     (= new-env (record-put name (partial-eval-exp rhs env) env))
     (partial-eval-exp body new-env))))

(define (partial-eval-ineg r)
  (match r
    ((int-exp n)
     (int-exp (ineg n)))
    (else
     (prim-exp 'ineg [r]))))

(define (partial-eval-iadd r1 r2)
  (match [r1 r2]
    ([(int-exp n1) (prim-exp 'iadd [(int-exp n2) e])]
     (prim-exp 'iadd [(int-exp (iadd n1 n2)) e]))
    ([(int-exp n1) (int-exp n2)]
     (int-exp (iadd n1 n2)))
    ;; keep int on the left of iadd.
    ([r1 (int-exp n2)]
     (partial-eval-iadd r2 r1))
    (else
     (prim-exp 'iadd [r1 r2]))))

(define (partial-eval-isub r1 r2)
  (match [r1 r2]
    ([(int-exp n1) (int-exp n2)]
     (int-exp (isub n1 n2)))
    (else
     (prim-exp 'isub [r1 r2]))))

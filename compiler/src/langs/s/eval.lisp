(import-all "deps")
(import-all "index")

(export eval-mod)

(claim eval-mod (-> mod? value?))

(define (eval-mod mod)
  (match mod
    ((cons-mod info exp)
     (eval-exp exp []))))

(claim eval-exp
  (-> exp? (record? value?) value?))

(define (eval-exp exp env)
  (match exp
    ((int-exp n) n)
    ((bool-exp b) b)
    (void-exp #void)
    ((var-exp name)
     (= found (record-get name env))
     (when (null? found)
       (exit [:who 'eval-exp
              :message "undefined name"
              :name name]))
     found)
    ((if-exp condition then else)
     (if (eval-exp condition env)
       (eval-exp then env)
       (eval-exp else env)))
    ((prim-exp 'and [e1 e2])
     (if (not (eval-exp e1 env)) false (eval-exp e2 env)))
    ((prim-exp 'or [e1 e2])
     (if (eval-exp e1 env) true (eval-exp e2 env)))
    ((prim-exp op args)
     (apply (record-get op operator-prims)
       (list-map (swap eval-exp env) args)))
    ((let-exp name rhs body)
     (= new-env (record-put name (eval-exp rhs env) env))
     (eval-exp body new-env))
    ((begin-exp sequence)
     (list-each (swap eval-exp env) (list-init sequence))
     (eval-exp (list-last sequence) env))
    ((the-exp type exp)
     (eval-exp exp env))))

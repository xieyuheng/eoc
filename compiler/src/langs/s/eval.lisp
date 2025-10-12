(import-all "deps")
(import-all "index")

(export eval-program)

(claim eval-program (-> program? value?))

(define (eval-program program)
  (match program
    ((cons-program info exp)
     (eval-exp exp []))))

(claim eval-exp
  (-> exp? (record? value?) value?))

(define (eval-exp exp env)
  (match exp
    ((int-exp n) n)
    ((bool-exp b) b)
    ((var-exp name)
     (= found (record-get name env))
     (when (null? found)
       (exit [:who 'eval-exp
              :message "undefined name"
              :name name]))
     found)
    ((if-exp condition consequent alternative)
     (if (eval-exp condition env)
       (eval-exp consequent env)
       (eval-exp alternative env)))
    ((prim-exp 'and [e1 e2])
     (if (not (eval-exp e1 env)) false (eval-exp e2 env)))
    ((prim-exp 'or [e1 e2])
     (if (eval-exp e1 env) true (eval-exp e2 env)))
    ((prim-exp op args)
     (apply (record-get op op-prims)
       (list-map (swap eval-exp env) args)))
    ((let-exp name rhs body)
     (= new-env (record-put name (eval-exp rhs env) env))
     (eval-exp body new-env))))

(define op-prims
  [:iadd iadd
   :isub isub
   :ineg ineg
   :random-dice (thunk (iadd 1 (random-int 0 5)))
   :not not
   :eq? equal?
   :lt? int-smaller?
   :gt? int-larger?
   :lteq? int-smaller-or-equal?
   :gteq? int-larger-or-equal?])

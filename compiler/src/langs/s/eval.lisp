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
    ((var-exp name)
     (= found (record-get name env))
     (when (null? found)
       (exit [:who 'eval-exp
              :message "undefined name"
              :name name]))
     found)
    ((prim-exp op args)
     (eval-prim op args env))
    ((let-exp name rhs body)
     (= new-env (record-put name (eval-exp rhs env) env))
     (eval-exp body new-env))))

(claim eval-prim
  (-> symbol? (list? exp?) (record? value?) value?))

;; (define (eval-prim op args env)
;;   (match [op args]
;;     (['iadd [x y]]
;;      (iadd (eval-exp x env) (eval-exp y env)))
;;     (['isub [x y]]
;;      (isub (eval-exp x env) (eval-exp y env)))
;;     (['ineg [x]]
;;      (ineg (eval-exp x env)))
;;     (['random-dice []]
;;      (iadd 1 (random-int 0 5)))))

(define (eval-prim op args env)
  (apply (eval-op op) (list-map (swap eval-exp env) args)))

(claim eval-op (-> symbol? (*-> value? value?)))

(define (eval-op op)
  (match op
    ('iadd iadd)
    ('isub isub)
    ('ineg ineg)
    ('random-dice (thunk (iadd 1 (random-int 0 5))))))

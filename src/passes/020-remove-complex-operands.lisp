(import-all "deps.lisp")

(define (rco-program program)
  (match program
    ((cons-program info body)
     (cons-program info (rco-exp body)))))

(claim rco-exp (-> exp? exp?))

(define (rco-exp exp)
  (match exp
    ((var-exp name)
     (var-exp name))
    ((int-exp n)
     (int-exp n))
    ((let-exp name rhs body)
     (let-exp name (rco-exp rhs) (rco-exp body)))
    ((prim-exp op args)
     (= [new-args bindings-list] (list-unzip (list-map rco-atom args)))
     (= bindings (list-append-many bindings-list))
     (make-lets bindings (prim-exp op new-args)))))

(claim make-lets
  (-> (list? (tau symbol? exp?)) exp? exp?))

(define (make-lets bindings base-exp)
  (match bindings
    ('()
     base-exp)
    ((cons [name exp] rest-bindings)
     (make-lets rest-bindings (let-exp name exp base-exp)))))

(claim rco-atom
  (-> exp? (tau exp? (list? (tau symbol? exp?)))))

(define (rco-atom exp)
  (match exp
    ((var-exp name)
     [(var-exp name) []])
    ((int-exp n)
     [(int-exp n) []])
    ((let-exp name rhs body)
     (= [new-body bindings] (rco-atom body))
     [new-body
      (cons [name (rco-exp rhs)] bindings)])
    ((prim-exp op args)
     (= [new-args bindings-list] (list-unzip (list-map rco-atom args)))
     (= bindings (list-append-many bindings-list))
     (= name (freshen 'tmp))
     [(var-exp name)
      (cons [name (prim-exp op new-args)] bindings)])))

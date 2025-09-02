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
     (= [new-args bindings] (rco-args args))
     (make-lets bindings (prim-exp op new-args)))))

(claim rco-args
  (-> (list? exp?)
      (tau (list? exp?)
           (list? (tau symbol? exp?)))))

(define (rco-args args)
  (= [new-args bindings-list] (list-unzip (list-map rco-arg args)))
  [new-args (list-append-many bindings-list)])

(claim rco-arg
  (-> exp?
      (tau exp?
           (list? (tau symbol? exp?)))))

(define (rco-arg exp)
  (match exp
    ((var-exp name)
     [(var-exp name) []])
    ((int-exp n)
     [(int-exp n) []])
    ((let-exp name rhs body)
     (= [new-body bindings] (rco-arg body))
     [new-body
      (cons [name (rco-exp rhs)] bindings)])
    ((prim-exp op args)
     (= [new-args bindings] (rco-args args))
     (= name (freshen '_))
     [(var-exp name)
      (cons [name (prim-exp op new-args)] bindings)])))

(claim make-lets
  (-> (list? (tau symbol? exp?)) exp? exp?))

(define (make-lets bindings base-exp)
  (match bindings
    ([]
     base-exp)
    ((cons [name exp] rest-bindings)
     (make-lets rest-bindings (let-exp name exp base-exp)))))

(define freshen-state [:count 0])

(define (freshen name)
  (= count (record-get 'count freshen-state))
  (record-set! 'count (iadd 1 count) freshen-state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

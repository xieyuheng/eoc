(import-all "deps.lisp")

(define (rco-program program)
  (match program
    ((cons-program info body)
     (cons-program info (rco-exp body)))))

(define freshen-state [:count 0])

(define (freshen name)
  (= count (record-get 'count freshen-state))
  (record-set! 'count (iadd 1 count) freshen-state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

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

;; we must use (list? (tau symbol? exp?)) instead of (record? exp?),
;; because we need to control the order of entries.
;; the binding of the inner arg should be cons-ed at the out side.
;; > (+ (+ 1 2) (+ 3 (+ 4 5)))
;; = (let ((_₃ (+ 4 5)))
;;     (let ((_₄ (+ 3 _₃)))
;;       (let ((_₂ (+ 1 2)))
;;         (+ _₂ _₄))))

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

(define (rco-arg arg)
  (match arg
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

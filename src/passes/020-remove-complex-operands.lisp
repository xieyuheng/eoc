(import-all "deps.lisp")

(export rco-program atom-operand-exp?)

(define (rco-program program)
  (match program
    ((cons-program info body)
     (cons-program info (rco-exp [:count 0] body)))))

(define state? (tau :count int-non-negative?))

(claim freshen (-> state? symbol? symbol?))

(define (freshen state name)
  (= count (record-get 'count state))
  (record-set! 'count (iadd 1 count) state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

(claim atom-operand-exp? (-> exp? bool?))

(define (atom-operand-exp? exp)
  (match exp
    ((var-exp name)
     true)
    ((int-exp n)
     true)
    ((let-exp name rhs body)
     (and (atom-operand-exp? rhs)
          (atom-operand-exp? body)))
    ((prim-exp op args)
     (list-all? atom-exp? args))))

(claim rco-exp (-> state? exp? atom-operand-exp?))

(define (rco-exp state exp)
  (match exp
    ((var-exp name)
     (var-exp name))
    ((int-exp n)
     (int-exp n))
    ((let-exp name rhs body)
     (let-exp name (rco-exp state rhs) (rco-exp state body)))
    ((prim-exp op args)
     (= [new-args bindings] (rco-args state args))
     (make-lets bindings (prim-exp op new-args)))))

;; we must use `(list? (tau symbol? exp?))` instead of `(record? exp?)`,
;; because we need to control the order of entries.
;; the binding of the inner arg should be cons-ed at the out side.
;; for example:
;; > (iadd (iadd 1 2) (iadd 3 (iadd 4 5)))
;; = (let ((_₂ (iadd 4 5)))
;;     (let ((_₃ (iadd 3 _₂)))
;;       (let ((_₁ (iadd 1 2)))
;;         (iadd _₁ _₃))))

;; TODO `rco-arg` and `rco-args` use writer monad,
;; we should make this explicit.

;; TODO we should also avoid side effect on state
;; by using state monad.

(claim rco-args
  (-> state? (list? exp?)
      (tau (list? atom-operand-exp?)
           (list? (tau symbol? atom-operand-exp?)))))

(define (rco-args state args)
  (= [new-args bindings-list] (list-unzip (list-map (rco-arg state) args)))
  [new-args (list-append-many bindings-list)])

(claim rco-arg
  (-> state? exp?
      (tau atom-operand-exp?
           (list? (tau symbol? atom-operand-exp?)))))

(define (rco-arg state arg)
  (match arg
    ((var-exp name)
     [(var-exp name) []])
    ((int-exp n)
     [(int-exp n) []])
    ((let-exp name rhs body)
     (= [new-body bindings] (rco-arg state body))
     ;; use `rco-exp` instead of `rco-arg` on `rhs`,
     ;; `rco-arg` should only be used on exp at the arg position.
     [new-body
      (cons [name (rco-exp state rhs)] bindings)])
    ((prim-exp op args)
     (= [new-args bindings] (rco-args state args))
     (= name (freshen state '_))
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

(import-all "deps")

(export rco-program atom-operand-exp?)

(claim rco-program (-> program? program?))

(define (rco-program program)
  (match program
    ((cons-program info body)
     (= state [:count 0])
     (cons-program info (rco-exp state body)))))

(define state? (tau :count int-non-negative?))

(claim freshen (-> state? symbol? symbol?))

(define (freshen state name)
  (= count (record-get 'count state))
  (record-put! 'count (iadd 1 count) state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

;; (atom-operand-exp?)
;;
;;   To define the grammer of the result exp of (rco-exp).
;;   this grammer will direct (by result type) the implementation
;;   of structural recursive functions -- (rco-exp) and (rco-atom).

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

;; (rco-exp)
;;
;;   To make the operand position of an exp atomic.
;;   the bind of the inner arg should be cons-ed at the out side.
;;
;; example:
;;
;;   > (iadd (iadd 1 2) (iadd 3 (iadd 4 5)))
;;   = (let ((_₁ (iadd 1 2)))
;;       (let ((_₂ (iadd 4 5)))
;;         (let ((_₃ (iadd 3 _₂)))
;;           (iadd _₁ _₃))))

(claim rco-exp (-> state? exp? atom-operand-exp?))

(define (rco-exp state exp)
  (match exp
    ((var-exp name)
     (var-exp name))
    ((int-exp n)
     (int-exp n))
    ((let-exp name rhs body)
     (let-exp name
              (rco-exp state rhs)
              (rco-exp state body)))
    ((prim-exp op args)
     (= [binds new-args] (rco-atom-many state args))
     (prepend-lets binds (prim-exp op new-args)))))

(define bind? (tau symbol? atom-operand-exp?))

(claim prepend-lets
  (-> (list? bind?) exp? exp?))

(define (prepend-lets binds exp)
  (match binds
    ([]
     exp)
    ((cons [name rhs] rest-binds)
     (let-exp name rhs (prepend-lets rest-binds exp)))))

;; (rco-atom)
;;
;;   To make an exp atomic.
;;
;; example:
;;
;;   > (iadd 3 (iadd 4 5))
;;   = [[[_₂ (iadd 4 5)]
;;       [_₃ (iadd 3 _₂)]]
;;      _₃]
;;
;; - TODO (rco-atom) and (rco-atom-many) use writer monad,
;;   we should make this explicit.
;;
;; - TODO we should also avoid side effect on state
;;   by using state monad.

(claim rco-atom
  (-> state? exp?
      (tau (list? bind?)
           atom-operand-exp?)))

(define (rco-atom state exp)
  (match exp
    ((var-exp name)
     [[] (var-exp name)])
    ((int-exp n)
     [[] (int-exp n)])
    ((let-exp name rhs body)
     ;; We use (rco-exp) instead of (rco-atom) on rhs,
     ;; (rco-atom) should only be used on
     ;; exp at the operand position.
     (= rhs-bind [name (rco-exp state rhs)])
     (= [binds new-body] (rco-atom state body))
     [(cons rhs-bind binds)
      new-body])
    ((prim-exp op args)
     (= [binds new-args] (rco-atom-many state args))
     (= name (freshen state '_))
     [(list-push [name (prim-exp op new-args)] binds)
      (var-exp name)])))

(claim rco-atom-many
  (-> state? (list? exp?)
      (tau (list? bind?)
           (list? atom-operand-exp?))))

(define (rco-atom-many state exps)
  (= [binds-list new-exps] (list-unzip (list-map (rco-atom state) exps)))
  [(list-append-many binds-list) new-exps])

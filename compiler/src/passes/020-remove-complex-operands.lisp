(import-all "deps")

(export rco-mod atom-operand-exp?)

(claim rco-mod (-> mod? mod?))

(define (rco-mod mod)
  (match mod
    ((cons-mod info body)
     (= state [:count 0])
     (cons-mod info (rco-exp state body)))))

(define state? (tau :count int-non-negative?))

(claim freshen (-> state? symbol? symbol?))

(define (freshen state name)
  (= count (record-get 'count state))
  (record-put! 'count (iadd 1 count) state)
  (symbol-append name (string-to-symbol (format-subscript (iadd 1 count)))))

(claim atom-operand-exp? (-> exp? bool?))

(@comment
  To define the grammer of the result exp of (rco-exp).
  this grammer will direct (by result type) the implementation
  of structural recursive functions -- (rco-exp) and (rco-atom).)

(define (atom-operand-exp? exp)
  (match exp
    ((var-exp name)
     true)
    ((int-exp value)
     true)
    ((bool-exp value)
     true)
    ((if-exp condition then else)
     (and (atom-operand-exp? condition)
          (atom-operand-exp? then)
          (atom-operand-exp? else)))
    ((let-exp name rhs body)
     (and (atom-operand-exp? rhs)
          (atom-operand-exp? body)))
    ((prim-exp op args)
     (list-all? atom-exp? args))))

(claim rco-exp (-> state? exp? atom-operand-exp?))

(@comment
  To make the operand position of an exp atomic.
  the bind of the inner arg should be cons-ed at the out side.

  >> (rco-exp (iadd (iadd 1 2) (iadd 3 (iadd 4 5))))
  => (let ((_₁ (iadd 1 2)))
       (let ((_₂ (iadd 4 5)))
         (let ((_₃ (iadd 3 _₂)))
           (iadd _₁ _₃)))))

(define (rco-exp state exp)
  (match exp
    ((var-exp name)
     (var-exp name))
    ((int-exp value)
     (int-exp value))
    ((bool-exp value)
     (bool-exp value))
    ((let-exp name rhs body)
     (let-exp name
              (rco-exp state rhs)
              (rco-exp state body)))
    ((if-exp condition then else)
     (if-exp (rco-exp state condition)
             (rco-exp state then)
             (rco-exp state else)))
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

(claim rco-atom
  (-> state? exp?
      (tau (list? bind?)
           atom-operand-exp?)))

(@comment
  To make an exp atomic.

  >> (iadd 3 (iadd 4 5))
  => [[[_₂ (iadd 4 5)]
       [_₃ (iadd 3 _₂)]]
      _₃])

;; TODO (rco-atom) and (rco-atom-many) use writer monad,
;; we should make this explicit.

;; TODO we should also avoid side effect on state
;; by using state monad.

(define (rco-atom state exp)
  (match exp
    ((var-exp name)
     [[] (var-exp name)])
    ((int-exp value)
     [[] (int-exp value)])
    ((int-exp value)
     [[] (int-exp value)])
    ((let-exp name rhs body)
     ;; We use (rco-exp) instead of (rco-atom) on rhs,
     ;; (rco-atom) should only be used on
     ;; exp at the operand position.
     (= rhs-bind [name (rco-exp state rhs)])
     (= [binds new-body] (rco-atom state body))
     [(cons rhs-bind binds)
      new-body])
    ((if-exp condition then else)
     (= name (freshen state '_))
     [[[name (rco-exp state exp)]]
      (var-exp name)])
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
  [(list-concat binds-list) new-exps])

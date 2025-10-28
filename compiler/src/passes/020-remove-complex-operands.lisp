(import-all "deps")

;; Unnest operands by translating to assignments (let)
;; with the help of generated temporary variables.

(export
  remove-complex-operands
  typed-atom-operand-exp?)

(claim remove-complex-operands (-> mod? mod?))

(define (remove-complex-operands mod)
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

(claim typed-atom-operand-exp? (-> exp? bool?))

(@comment
  To define the grammer of the result exp of (rco-exp).
  this grammer will direct (by result type) the implementation
  of structural recursive functions -- (rco-exp) and (rco-atom).)

(define (typed-atom-operand-exp? exp)
  (match exp
    ((the-exp type (var-exp name))
     true)
    ((the-exp type (int-exp value))
     true)
    ((the-exp type (bool-exp value))
     true)
    ((the-exp type (if-exp condition then else))
     (and (typed-atom-operand-exp? condition)
          (typed-atom-operand-exp? then)
          (typed-atom-operand-exp? else)))
    ((the-exp type (let-exp name rhs body))
     (and (typed-atom-operand-exp? rhs)
          (typed-atom-operand-exp? body)))
    ((the-exp type (prim-exp op args))
     (list-all? typed-atom-exp? args))
    (_ false)))

(define (typed-atom-exp? exp)
  (and (the-exp? exp) (atom-exp? (the-exp-exp exp))))

(claim rco-exp
  (-> state? typed-exp?
      typed-atom-operand-exp?))

(@comment
  To make the operand position of an exp atomic.
  the bind of the inner arg should be cons-ed at the out side.

  >> (rco-exp (iadd (iadd 1 2) (iadd 3 (iadd 4 5))))
  => (let ((_₁ (iadd 1 2)))
       (let ((_₂ (iadd 4 5)))
         (let ((_₃ (iadd 3 _₂)))
           (iadd _₁ _₃)))))

(define (rco-exp state exp)
  (if (atom-exp? (the-exp-exp exp))
    exp
    (match exp
      ((the-exp type (let-exp name rhs body))
       (the-exp type
                (let-exp name
                         (rco-exp state rhs)
                         (rco-exp state body))))
      ((the-exp type (if-exp condition then else))
       (the-exp type (if-exp (rco-exp state condition)
                             (rco-exp state then)
                             (rco-exp state else))))
      ((the-exp type (prim-exp op args))
       (= [binds new-args] (rco-atom-many state args))
       (prepend-lets type binds (the-exp type (prim-exp op new-args)))))))

(define bind? (tau symbol? typed-atom-operand-exp?))

(claim prepend-lets
  (-> type? (list? bind?) typed-exp? typed-exp?))

(define (prepend-lets type binds exp)
  (match binds
    ([]
     exp)
    ((cons [name rhs] rest-binds)
     (the-exp type (let-exp name rhs (prepend-lets type rest-binds exp))))))

(claim rco-atom
  (-> state? typed-exp?
      (tau (list? bind?)
           typed-atom-operand-exp?)))

(@comment
  To make an exp atomic.

  >> (iadd 3 (iadd 4 5))
  => [[[_₂ (iadd 4 5)]
       [_₃ (iadd 3 _₂)]]
      _₃])

;; TODO (rco-atom) and (rco-atom-many) use writer monad,
;; we should make this explicit.

(define (rco-atom state exp)
  (if (atom-exp? (the-exp-exp exp))
    [[] exp]
    (match exp
      ((the-exp type (let-exp name rhs body))
       ;; We use (rco-exp) instead of (rco-atom) on rhs,
       ;; (rco-atom) should only be used on
       ;; exp at the operand position.
       (= rhs-bind [name (rco-exp state rhs)])
       (= [binds new-body] (rco-atom state body))
       [(cons rhs-bind binds)
        new-body])
      ((the-exp type (if-exp condition then else))
       (= name (freshen state '_))
       [[[name (rco-exp state exp)]]
        (the-exp type (var-exp name))])
      ((the-exp type (prim-exp op args))
       (= [binds new-args] (rco-atom-many state args))
       (= name (freshen state '_))
       [(list-push [name (the-exp type (prim-exp op new-args))] binds)
        (the-exp type (var-exp name))]))))

(claim rco-atom-many
  (-> state? (list? typed-exp?)
      (tau (list? bind?)
           (list? typed-atom-operand-exp?))))

(define (rco-atom-many state exps)
  (= [binds-list new-exps] (list-unzip (list-map (rco-atom state) exps)))
  [(list-concat binds-list) new-exps])

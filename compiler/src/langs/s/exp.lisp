(import-all "deps")

(export
  exp?
  var-exp int-exp bool-exp void-exp if-exp prim-exp let-exp the-exp
  var-exp? int-exp? bool-exp? void-exp? if-exp? prim-exp? let-exp? the-exp?
  the-exp-type
  the-exp-exp
  atom-exp? typed-exp?)

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (bool-exp (value bool?))
  void-exp
  (if-exp (condition exp?) (then exp?) (else exp?))
  (prim-exp (op symbol?) (args (list? exp?)))
  (let-exp (name symbol?) (rhs exp?) (body exp?))
  (the-exp (type type?) (exp exp?)))

(define atom-exp?
  (union var-exp?
         int-exp?
         bool-exp?
         void-exp?))

(define (typed-exp? exp)
  (and (the-exp? exp)
       (match (the-exp-exp exp)
         ((var-exp name) true)
         ((int-exp value) true)
         ((bool-exp value) true)
         (void-exp true)
         ((if-exp condition then else)
          (and (typed-exp? condition)
               (typed-exp? then)
               (typed-exp? else)))
         ((prim-exp op args)
          (list-all? typed-exp? args))
         ((let-exp name rhs body)
          (and (typed-exp? rhs)
               (typed-exp? body)))
         ((the-exp type inner-exp)
          (typed-exp? (the-exp type inner-exp))))))

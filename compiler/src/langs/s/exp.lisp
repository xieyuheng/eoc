(import-all "deps")

(export
  exp?
  var-exp int-exp bool-exp if-exp prim-exp let-exp the-exp
  var-exp? int-exp? bool-exp? if-exp? prim-exp? let-exp? the-exp?
  atom-exp? typed-exp?)

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (bool-exp (value bool?))
  (if-exp (condition exp?) (then exp?) (else exp?))
  (prim-exp (op symbol?) (args (list? exp?)))
  (let-exp (name symbol?) (rhs exp?) (body exp?))
  (the-exp (type type?) (exp exp?)))

(define atom-exp?
  (union var-exp?
         int-exp?
         bool-exp?))

(define (typed-exp? exp)
  (and (the-exp? exp)
       (typed-exp? (the-exp-exp exp))))

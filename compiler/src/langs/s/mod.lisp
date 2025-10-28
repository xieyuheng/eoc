(export
  mod? cons-mod
  exp?
  var-exp int-exp bool-exp if-exp prim-exp let-exp
  var-exp? int-exp? bool-exp? if-exp? prim-exp? let-exp?
  atom-exp?)

(define-data mod?
  (cons-mod
   (info anything?)
   (body exp?)))

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (bool-exp (value bool?))
  (if-exp (condition exp?) (then exp?) (else exp?))
  (prim-exp (op symbol?) (args (list? exp?)))
  (let-exp (name symbol?) (rhs exp?) (body exp?)))

(define atom-exp?
  (union var-exp?
         int-exp?
         bool-exp?))

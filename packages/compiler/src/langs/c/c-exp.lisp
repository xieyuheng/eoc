(import-all "deps")

(export
  c-exp?
  var-c-exp int-c-exp bool-c-exp void-c-exp prim-c-exp
  var-c-exp? int-c-exp? bool-c-exp? void-c-exp? prim-c-exp?
  atom-c-exp?
  cmp-op?
  cmp-c-exp?)

(define-data c-exp?
  (var-c-exp (name symbol?))
  (int-c-exp (value int?))
  (bool-c-exp (value bool?))
  void-c-exp
  (prim-c-exp (op symbol?) (args (list? atom-c-exp?))))

(define atom-c-exp?
  (union var-c-exp?
         int-c-exp?
         bool-c-exp?
         void-c-exp?))

(define cmp-ops '(eq? lt? gt? lteq? gteq?))
(define cmp-op? (swap list-member? cmp-ops))

(define cmp-c-exp?
  (inter prim-c-exp?
         (lambda (c-exp)
           (cmp-op? (prim-c-exp-op c-exp)))))

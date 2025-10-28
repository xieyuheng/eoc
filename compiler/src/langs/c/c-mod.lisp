(export
  c-mod? cons-c-mod
  c-mod/info?
  seq? cons-seq return-seq goto-seq branch-seq
  cons-seq? return-seq? goto-seq? branch-seq?
  stmt? assign-stmt
  c-exp? var-c-exp int-c-exp bool-c-exp prim-c-exp
  atom-c-exp?
  cmp-op?
  cmp-c-exp?)

(define-data c-mod?
  (cons-c-mod
   (info anything?)
   (seqs (record? seq?))))

(claim c-mod/info?
  (-> (-> anything? bool?) c-mod?
      bool?))

(define (c-mod/info? info-p c-mod)
  (info-p (cons-c-mod-info c-mod)))

(define-data seq?
  (cons-seq (stmt stmt?) (tail seq?))
  (return-seq (result c-exp?))
  (goto-seq (label symbol?))
  (branch-seq (condition cmp-c-exp?)
              (then-label symbol?)
              (else-label symbol?)))

(define-data stmt?
  (assign-stmt (var var-c-exp?) (rhs c-exp?)))

(define-data c-exp?
  (var-c-exp (name symbol?))
  (int-c-exp (value int?))
  (bool-c-exp (value bool?))
  (prim-c-exp (op symbol?) (args (list? atom-c-exp?))))

(define atom-c-exp?
  (union var-c-exp?
         int-c-exp?
         bool-c-exp?))

(define cmp-ops '(eq? lt? gt? lteq? gteq?))
(define cmp-op? (swap list-member? cmp-ops))

(define cmp-c-exp?
  (inter prim-c-exp?
         (lambda (c-exp)
           (cmp-op? (prim-c-exp-op c-exp)))))

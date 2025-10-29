(import-all "deps")
(import-all "c-exp")

(export
  c-mod? cons-c-mod
  c-mod/info?
  seq? cons-seq return-seq goto-seq branch-seq
  cons-seq? return-seq? goto-seq? branch-seq?
  stmt?
  assign-stmt effect-stmt
  assign-stmt? effect-stmt?)

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
  (assign-stmt (var var-c-exp?) (type type?) (rhs c-exp?))
  (effect-stmt (rhs c-exp?)))

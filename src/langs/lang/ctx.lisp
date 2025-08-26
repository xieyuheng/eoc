(import-all "index.lisp")

(define-data ctx?
  empty-ctx
  (cons-ctx (name symbol?) (type type?) (rest ctx?)))

(claim ctx-lookup (-> symbol? ctx? type?))

(define (ctx-lookup name ctx)
  (match ctx
    (empty-ctx null)
    ((cons-ctx key type rest)
     (if (equal? key name)
       type
       (ctx-lookup name rest)))))

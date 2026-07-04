(import-all "deps")

(export check-type)

(claim check-type (-> mod? mod?))

(define (check-type mod)
  (check-mod mod))

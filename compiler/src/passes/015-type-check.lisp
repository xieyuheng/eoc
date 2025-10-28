(import-all "deps")

(export type-check)

(claim type-check (-> mod? mod?))

(define (type-check mod)
  (check-mod mod))

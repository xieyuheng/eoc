(import-all "deps")
(import-all "exp")

(export
  mod? cons-mod)

(define-data mod?
  (cons-mod
   (info any?)
   (body exp?)))

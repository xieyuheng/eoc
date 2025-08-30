(import-all "index.lisp")

(define-data program?
  (cons-program
   (info anything?)
   (body exp?)))

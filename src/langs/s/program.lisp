(import-all "index.lisp")

;; <program> ::= (Program '() <exp>)

(define-data program?
  (make-program
   (info anything?)
   (body exp?)))

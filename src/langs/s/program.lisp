(import-all "index.lisp")

;; <program> ::= (Program '() <exp>)

(define-data program?
  (cons-program
   (info anything?)
   (body exp?)))

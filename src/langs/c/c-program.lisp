(import-all "index.lisp")

(define-data c-program?
  (cons-c-program
   (info anything?)
   (seqs (record? seq?))))

;; the book uses <tail> but it is a wrong name,
;; because it is the name of the field,
;; not the name of the data type.

(define-data seq?
  (return-seq (result c-exp?))
  (cons-seq (stmt stmt?) (tail seq?)))

(define-data stmt?
  (assign-stmt (var var-c-exp?) (rhs c-exp?)))

(define-data c-exp?
  (var-c-exp (name symbol?))
  (int-c-exp (value int?))
  (prim-c-exp (op symbol?) (args (list? c-atom?))))

(define c-atom? (union var-c-exp? int-c-exp?))

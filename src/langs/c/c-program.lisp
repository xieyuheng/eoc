(export
  c-program? cons-c-program
  seq? return-seq cons-seq
  stmt? assign-stmt
  c-exp? var-c-exp int-c-exp prim-c-exp
  c-exp-atom?)

(define-data c-program?
  (cons-c-program
   (info anything?)
   (seqs (record? seq?))))

(define-data seq?
  (return-seq (result c-exp?))
  (cons-seq (stmt stmt?) (tail seq?)))

(define-data stmt?
  (assign-stmt (var var-c-exp?) (rhs c-exp?)))

(define-data c-exp?
  (var-c-exp (name symbol?))
  (int-c-exp (value int?))
  (prim-c-exp (op symbol?) (args (list? c-exp-atom?))))

(define c-exp-atom? (union var-c-exp? int-c-exp?))

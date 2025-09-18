(export
  c-program? cons-c-program
  c-program-with-info?
  seq? return-seq cons-seq
  stmt? assign-stmt
  c-exp? var-c-exp int-c-exp prim-c-exp
  c-exp-atom?)

(define-data c-program?
  (cons-c-program
   (info anything?)
   (seqs (record? seq?))))

(claim c-program-with-info?
  (-> (-> anything? bool?) c-program?
      bool?))

(define (c-program-with-info? info-p)
  (lambda (c-program)
    (and (c-program? c-program)
         (info-p (cons-c-program-info c-program)))))

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

(import-all "index.lisp")

;; <atm> ::= (Int <int>)
;;         | (Var <var>)
;; <exp> ::= <atm>
;;         | (Prim 'read ())
;;         | (Prim '- (<atm>))
;;         | (Prim '+ (<atm> <atm>))
;;         | (Prim '- (<atm> <atm>))
;; <stmt> ::= (Assign (Var <var>) <exp>)
;; <tail> ::= (Return <exp>)
;;          | (Seq <stmt> <tail>)
;; <c-program> ::= (CProgram <info> ((<label> . <tail>) … ))

(define-data program?
  (cons-program
   (info info?)
   (seqs (record? seq?))))

(define info? anything?)

;; the book uses <tail> but it is a wrong name,
;; because it is the name of the field,
;; not the name of the data type.

(define-data seq?
  (return-seq (result exp?))
  (cons-seq (stmt stmt?) (tail seq?)))

(define-data stmt?
  (assign-stmt (var var-exp?) (rhs exp?)))

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (prim-exp (op op?) (args (list? atom-exp?))))

(define op? symbol?)

(define atom-exp? (union var-exp? int-exp?))

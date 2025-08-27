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

(define atom-exp? (union var-exp? int-exp?))

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (prim-exp (op op?) (args (list? atom-exp?))))

(define-data stmt?
  (assign-stmt (var var-exp?) (rhs exp?)))

;; <tail> is a wrong name,
;; because it is the name of the field,
;; not the name of the data type.

(define-data seq?
  (last-seq (exp exp?))
  (cons-seq (stmt stmt?) (tail seq?)))

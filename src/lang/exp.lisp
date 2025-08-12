;; <type> ::= Integer
;; <exp> ::= (Int <int>)
;;         | (Var <var>)
;;         | (Prim 'read ())
;;         | (Prim '- (<exp>))
;;         | (Prim '+ (<exp> <exp>))
;;         | (Prim '- (<exp> <exp>))
;;         | (Let <var> <exp> <exp>)
;; <program> ::= (Program '() <exp>)

(define-data exp?
  (var-exp (name symbol?))
  (int-exp (value int?))
  (prim-exp (op symbol?) (args (list? exp?)))
  (let-exp (name symbol?) (rhs exp?) (body exp?)))

(var-exp 'x)

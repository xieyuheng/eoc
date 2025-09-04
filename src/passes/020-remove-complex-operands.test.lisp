(import-all "deps.lisp")
(import-all "index.lisp")

(assert
  (atom-operand-exp?
   (prim-exp '+ [(var-exp 'x) (int-exp 1)])))

(assert-not
  (atom-operand-exp?
   (prim-exp '+ [(prim-exp '+ [(var-exp 'x) (int-exp 1)])
                 (int-exp 1)])))

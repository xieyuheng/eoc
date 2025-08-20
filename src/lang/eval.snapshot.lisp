(import-all "program.lisp")
(import-all "env.lisp")
(import-all "eval.lisp")

((eval-exp (int-exp 8))
 empty-env)

((eval-exp (prim-exp '- [(int-exp 8)]))
 empty-env)

((eval-exp (prim-exp '+ [(prim-exp '+ [(int-exp 8)])
                         (prim-exp '- [(int-exp 8)])]))
 empty-env)

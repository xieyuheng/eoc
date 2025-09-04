(import-all "deps.lisp")
(import-all "index.lisp")

(assert
  (unnested-exp?
   (prim-exp '+ [(var-exp 'x) (int-exp 1)])))

(assert-not
  (unnested-exp?
   (prim-exp '+ [(prim-exp '+ [(var-exp 'x) (int-exp 1)])
                 (int-exp 1)])))

(import-all "deps.lisp")
(import-all "index.lisp")

(check-program
 (parse-program
  ;; wrong arity, `iadd` should take two arguments.
  '(program () (iadd 8))))

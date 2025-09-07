(import-all "deps.lisp")
(import-all "index.lisp")

(check-program
 (parse-program
  ;; wrong arity
  '(program () (iadd 8))))

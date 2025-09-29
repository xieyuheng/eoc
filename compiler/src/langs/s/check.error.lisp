(import-all "deps")
(import-all "index")

(check-program
 (parse-program
  ;; wrong arity
  '(program () (iadd 8))))

(import-all "deps")
(import-all "index")

(check-mod
 (parse-mod
  ;; wrong arity
  '(mod () (iadd 8))))

(import-all "index.lisp")

(check-c-program
 (parse-c-program
  '(c-program
    ()
    (:start
     ;; wrong arity
     ((= x (ineg 1 2))
      (return x))))))

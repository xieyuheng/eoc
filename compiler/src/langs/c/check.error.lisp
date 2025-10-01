(import-all "index")

(check-c-program
 (parse-c-program
  '(c-program
    ()
    (:begin
     ;; wrong arity
     ((= x (ineg 1 2))
      (return x))))))

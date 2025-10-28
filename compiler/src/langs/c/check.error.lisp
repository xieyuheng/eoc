(import-all "index")

(check-c-mod
 (parse-c-mod
  '(c-mod
    ()
    (:begin
     ;; wrong arity
     ((= x (ineg 1 2))
      (return x))))))

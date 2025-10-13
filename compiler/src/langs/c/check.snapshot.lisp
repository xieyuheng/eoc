(import-all "deps")
(import-all "index")

(define (test-c-program sexp)
  (= c-program (parse-c-program sexp))
  (check-c-program c-program))

(test-c-program
 '(c-program
   ()
   (:begin
    ((= x (ineg 1))
     (return x)))))

(test-c-program
 '(c-program
   ()
   (:begin
    ((= x 8)
     (branch (gt? x 1) a b)))))

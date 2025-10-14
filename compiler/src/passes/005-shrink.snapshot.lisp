(import-all "deps")
(import-all "005-shrink")

(define (test-program sexp)
  (= program (parse-program sexp))
  (= shrinked-program (shrink program))
  (write ">> ") (write (format-sexp (form-program program)))
  (newline)
  (write "=> ") (write (format-sexp (form-program shrinked-program)))
  (newline))

(test-program
 '(program () (and (and e1 e2) (and e4 e4))))

(test-program
 '(program () (or (or e1 e2) (or e3 e4))))

(test-program
 '(program
   ()
   (let ((x 8))
     (if (and e1 e2)
       (iadd x x)
       (imul x x)))))

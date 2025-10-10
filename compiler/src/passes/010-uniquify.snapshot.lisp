(import-all "deps")
(import-all "010-uniquify")

(define (test-program sexp)
  (= program-0 (parse-program sexp))
  (write "000 ") (write (format-sexp (form-program program-0)))
  (write "\n")
  (= program-1 (uniquify program-0))
  (write "010 ") (write (format-sexp (form-program program-1)))
  (write "\n"))

(test-program
 '(program
   ()
   (let ((x 1))
     (iadd x (let ((x (let ((x 5))
                        (iadd x x))))
               (iadd x 100))))))

(test-program
 '(program
   ()
   (let ((x 1))
     (iadd x (let ((x (let ((y 5))
                        (iadd y x))))
               (iadd x 100))))))

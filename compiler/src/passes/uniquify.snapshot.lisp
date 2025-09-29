(import-all "deps")
(import-all "index")

(define (test-program sexp)
  (= program-0 (parse-program sexp))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (= program-1 (uniquify program-0))
  (write "010 ") (writeln (format-sexp (form-program program-1))))

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

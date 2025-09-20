(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program sexp)
  (= program (parse-program sexp))
  (= program-1 (uniquify program))
  (write "> ") (writeln (format-sexp (form-program program)))
  (write "= ") (writeln (format-sexp (form-program program-1))))

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

(import-all "deps")
(import-all "001-partial-eval")

(define (test-program sexp)
  (= program (parse-program sexp))
  (= partial-program (partial-eval-program program))
  (write ">> ") (write (format-sexp (form-program program)))
  (newline)
  (write "=> ") (write (format-sexp (form-program partial-program)))
  (newline))

(test-program
 '(program () 8))

(test-program
 '(program () (ineg 8)))

(test-program
 '(program () (let ((x 8)) (iadd x x))))

(test-program
 '(program () x))

(test-program
 '(program () (iadd x x)))

(test-program
 '(program () (iadd (ineg 8) x)))

(test-program
 '(program () (iadd (iadd 8 8) (ineg x))))

(test-program
 '(program
   ()
   (let ((x (random-dice)))
     (let ((y (random-dice)))
       (if (if (lt? x 1) (eq? x 0) (eq? x 2))
         (iadd y 2)
         (iadd y 10))))))

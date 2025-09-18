(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program sexp)
  (= program (parse-program sexp))
  (= partial-program (partial-eval-program program))
  (write "> ") (writeln (format-sexp (form-program program)))
  (write "= ") (writeln (format-sexp (form-program partial-program))))

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

(import-all "index.lisp")
(import-all "partial-eval.lisp")

(define (test-program sexp)
  (= program (parse-program sexp))
  (= partial-program (partial-eval-program program))
  (write "> ") (writeln (format-sexp (form-program program)))
  (write "= ") (writeln (format-sexp (form-program partial-program))))

(test-program
 '(program () 8))

(test-program
 '(program () (- 8)))

(test-program
 '(program () (let ((x 8)) (+ x x))))

(test-program
 '(program () x))

(test-program
 '(program () (+ x x)))

(test-program
 '(program () (+ (+ 8) x)))

(test-program
 '(program () (+ (+ 8 8) (- x))))

(test-program
 '(program () (+ (+ 8 8) (+ x))))

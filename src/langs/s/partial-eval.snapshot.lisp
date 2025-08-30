(import-all "index.lisp")
(import-all "partial-eval.lisp")

(define (test-program expected sexp)
  (= program (parse-program sexp))
  (= program (check-program program))
  (= partial-program (partial-eval-program program))
  (= result (eval-program program))
  (= partial-result (eval-program partial-program))
  (write "> ") (writeln (format-sexp (form-program program)))
  (write "= ") (writeln (format-sexp (form-program partial-program)))
  (assert-equal expected result)
  (assert-equal expected partial-result))

(test-program
 8
 '(program () 8))

(test-program
 -8
 '(program () (- 8)))

(test-program
 0
 '(program () (+ (+ 8) (- 8))))

(test-program
 16
 '(program () (let ((x 8)) (+ x x))))

(import-all "index.lisp")

(define (echo-program sexp)
  (pipe sexp
    parse-program
    format-program
    format-sexp))

(echo-program
 '(program () 8))

(echo-program
 '(program () (- 8)))

(echo-program
 '(program () (+ (+ 8) (- 8))))

(echo-program
 '(program () (let ((x 8)) (+ x x))))

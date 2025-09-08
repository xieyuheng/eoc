(import-all "deps.lisp")
(import-all "index.lisp")

(define (echo-program sexp)
  (pipe sexp
    parse-program
    form-program
    format-sexp
    writeln))

(echo-program
 '(program () 8))

(echo-program
 '(program () (ineg 8)))

(echo-program
 '(program () (iadd 8 (ineg 8))))

(echo-program
 '(program () (let ((x 8)) (iadd x x))))

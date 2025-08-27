(import-all "index.lisp")

(define (test-program expected sexp)
  (= program (parse-program sexp))
  (= program (check-program program))
  (= value (eval-program program))
  (assert-equal expected value))

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

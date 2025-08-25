(import-all "index.lisp")

(define (test-program sexp expected)
  (= program (parse-program sexp))
  (= value (eval-program program))
  (assert-equal value expected))

(test-program '(program () 8) 8)
(test-program '(program () (- 8)) -8)
(test-program '(program () (+ (+ 8) (- 8))) 0)
(test-program '(program () (let ((x 8)) (+ x x))) 16)

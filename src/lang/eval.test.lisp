(import-all "index.lisp")

(define-lazy (test-exp sexp expected)
  (= exp (parse-exp sexp))
  (= value (eval-exp exp empty-env))
  (assert-equal value expected))

(test-exp '8 8)
(test-exp '(- 8) -8)
(test-exp '(+ (+ 8) (- 8)) 0)
(test-exp '(let ((x 8)) (+ x x)) 16)

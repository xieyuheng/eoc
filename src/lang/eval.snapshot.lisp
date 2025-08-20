(import-all "index.lisp")

(define (run sexp)
  (= exp (parse-exp sexp))
  (eval-exp exp empty-env))

(run '8)
(run '(- 8))
(run '(+ (+ 8) (- 8)))

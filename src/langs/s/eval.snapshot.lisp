(import-all "index.lisp")

(define (run-program sexp)
  (= program (parse-program sexp))
  (= program (check-program program))
  (eval-program program))

(run-program
 '(program
   ()
   (show 8)))

(run-program
 '(program
   ()
   (show (let ((x 8)) (+ x x)))))

(import-all "deps.lisp")
(import-all "index.lisp")

(define (run-program sexp)
  (= program (parse-program sexp))
  (= program (check-program program))
  (eval-program program))

[:random-dice (run-program '(program () (random-dice)))]
[:random-dice (run-program '(program () (random-dice)))]
[:random-dice (run-program '(program () (random-dice)))]
[:random-dice (run-program '(program () (random-dice)))]
[:random-dice (run-program '(program () (random-dice)))]
[:random-dice (run-program '(program () (random-dice)))]

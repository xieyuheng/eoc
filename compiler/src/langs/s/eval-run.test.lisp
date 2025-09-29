(import-all "deps")
(import-all "index")

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

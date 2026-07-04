(import-all "deps")
(import-all "index")

(define (run-mod sexp)
  (= mod (parse-mod sexp))
  (= mod (check-mod mod))
  (eval-mod mod))

[:random-dice (run-mod '(mod () (random-dice)))]
[:random-dice (run-mod '(mod () (random-dice)))]
[:random-dice (run-mod '(mod () (random-dice)))]
[:random-dice (run-mod '(mod () (random-dice)))]
[:random-dice (run-mod '(mod () (random-dice)))]
[:random-dice (run-mod '(mod () (random-dice)))]

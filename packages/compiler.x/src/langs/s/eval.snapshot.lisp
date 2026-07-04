(import-all "deps")
(import-all "index")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (eval-mod mod)
  void)

(test-mod
 '(mod
   ()
   (begin
     (print-int 1)
     (newline)
     (print-int 2)
     (newline)
     (print-int 3)
     (newline))))

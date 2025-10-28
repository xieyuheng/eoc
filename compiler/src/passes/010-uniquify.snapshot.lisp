(import-all "deps")
(import-all "010-uniquify")

(define (test-mod sexp)
  (= mod-0 (parse-mod sexp))
  (write ">> ") (write (format-sexp (form-mod mod-0)))
  (newline)
  (= mod-1 (uniquify mod-0))
  (write "=> ") (write (format-sexp (form-mod mod-1)))
  (newline))

(test-mod
 '(mod
   ()
   (let ((x 1))
     (iadd x (let ((x (let ((x 5))
                        (iadd x x))))
               (iadd x 100))))))

(test-mod
 '(mod
   ()
   (let ((x 1))
     (iadd x (let ((x (let ((y 5))
                        (iadd y x))))
               (iadd x 100))))))

(test-mod
 '(mod
   ()
   (let ((x 8))
     (if (and e1 e2)
       (iadd x x)
       (imul x x)))))

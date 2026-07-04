(import-all "deps")
(import-all "005-shrink")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (= shrinked-mod (shrink mod))
  (write ">> ") (write (format-sexp (form-mod mod)))
  (newline)
  (write "=> ") (write (format-sexp (form-mod shrinked-mod)))
  (newline))

(test-mod
 '(mod () (and (and e1 e2) (and e4 e4))))

(test-mod
 '(mod () (or (or e1 e2) (or e3 e4))))

(test-mod
 '(mod
   ()
   (let ((x 8))
     (if (and e1 e2)
       (iadd x x)
       (imul x x)))))

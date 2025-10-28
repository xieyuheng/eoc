(import-all "deps")
(import-all "020-remove-complex-operands")

(define (test-mod sexp)
  (= mod-0 (parse-mod sexp))
  (write ">> ") (write (format-sexp (form-mod mod-0)))
  (newline)
  (= mod-1 (remove-complex-operands mod-0))
  (write "=> ") (write (format-sexp (form-mod mod-1)))
  (newline))

(test-mod
 '(mod
   ()
   (iadd x 1)))

(test-mod
 '(mod
   ()
   (iadd (iadd x 1) 1)))

(test-mod
 '(mod
   ()
   (let ((y (iadd x 1)))
     (iadd y 1))))

(test-mod
 '(mod
   ()
   (let ((y (iadd (iadd x 1) 1)))
     (iadd y 1))))

(test-mod
 '(mod
   ()
   (let ((x 8))
     (if (and e1 e2)
       (iadd x x)
       (imul x x)))))

(test-mod
 '(mod
   ()
   (let ((x (random-dice)))
     (let ((y (random-dice)))
       (if (if (lt? x 1) (eq? x 0) (eq? x 2))
         (iadd y 2)
         (iadd y 10))))))

(test-mod
 '(mod
   ()
   (let ((x (random-dice)))
     (let ((y (random-dice)))
       (iadd
        (if (if (lt? x 1) (eq? x 0) (eq? x 2))
          (iadd y 2)
          (iadd y 10))
        (if (if (lt? x 1) (eq? x 0) (eq? x 2))
          (iadd y 2)
          (iadd y 10)))))))

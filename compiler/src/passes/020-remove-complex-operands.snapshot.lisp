(import-all "deps")
(import-all "005-shrink")
(import-all "015-check-type")
(import-all "020-remove-complex-operands")

(define (test-mod sexp)
  (pipe sexp
    (compose (log-mod ">> ") parse-mod)
    (compose (log-mod ">> ") check-type shrink)
    (compose (log-mod "=> ") remove-complex-operands)
    (constant void)))

(define (log-mod prompt mod)
  (write prompt)
  (write (format-sexp (form-mod-without-type mod)))
  (newline)
  mod)

(test-mod
 '(mod
   ()
   (iadd 1 1)))

(test-mod
 '(mod
   ()
   (iadd (iadd 1 1) 1)))

(test-mod
 '(mod
   ()
   (let ((y (iadd 1 1)))
     (iadd y 1))))

(test-mod
 '(mod
   ()
   (let ((y (iadd (iadd 1 1) 1)))
     (iadd y 1))))

(test-mod
 '(mod
   ()
   (let ((x 8))
     (if (and #t #f)
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

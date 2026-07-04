(import-all "deps")
(import-all "005-shrink")
(import-all "010-uniquify")
(import-all "015-check-type")
(import-all "020-remove-complex-operands")
(import-all "030-explicate-control")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (write ">> ") (write (format-sexp (form-mod-without-type mod)))
  (newline)
  (= c-mod
     (pipe mod
       shrink
       uniquify
       check-type
       remove-complex-operands
       explicate-control))
  (write (format-after-prompt "=> " (pretty 80 c-mod)))
  (newline))

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

(test-mod
 '(mod
   ()
   (if (and (eq? (random-dice) 1)
            (eq? (random-dice) 2))
     0
     42)))

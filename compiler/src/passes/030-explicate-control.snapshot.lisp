(import-all "deps")
(import-all "index")

(define (test-mod sexp)
  (= mod (parse-mod sexp))
  (write ">> ") (write (format-sexp (form-mod mod)))
  (newline)
  (= c-mod
     (pipe mod
       shrink
       uniquify
       rco-mod
       explicate-control))
  (write (format-after-prompt "=> " (pretty 80 c-mod)))
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

(test-mod
 '(mod
   ()
   (if (and (eq? (random-dice) 1)
            (eq? (random-dice) 2))
     0
     42)))

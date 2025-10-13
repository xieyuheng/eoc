(import-all "deps")
(import-all "index")

(define (test-program sexp)
  (= program (parse-program sexp))
  (write ">> ") (write (format-sexp (form-program program)))
  (write "\n")
  (= c-program
     (pipe program
       shrink
       uniquify
       rco-program
       explicate-control))
  (write "=> ")
  (write "\n")
  (write (format-left-margin "   " (pretty 80 c-program)))
  (write "\n"))

(test-program
 '(program
   ()
   (iadd x 1)))

(test-program
 '(program
   ()
   (iadd (iadd x 1) 1)))

(test-program
 '(program
   ()
   (let ((y (iadd x 1)))
     (iadd y 1))))

(test-program
 '(program
   ()
   (let ((y (iadd (iadd x 1) 1)))
     (iadd y 1))))

(test-program
 '(program
   ()
   (let ((x 8))
     (if (and e1 e2)
       (iadd x x)
       (imul x x)))))

(test-program
 '(program
   ()
   (let ((x (random-dice)))
     (let ((y (random-dice)))
       (if (if (lt? x 1) (eq? x 0) (eq? x 2))
         (iadd y 2)
         (iadd y 10))))))

(test-program
 '(program
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

(test-program
 '(program
   ()
   (if (and (eq? (random-dice) 1)
            (eq? (random-dice) 2))
     0
     42)))

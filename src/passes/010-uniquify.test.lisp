(import-all "../langs/s/index.lisp")
(import-all "010-uniquify.lisp")

(define (test-program program-sexp value)
  (= program-0 (parse-program program-sexp))
  (= program-1 (uniquify program-0))
  (= result (eval-program program-1))
  (write "000 ") (writeln (format-sexp (format-program program-0)))
  (write "010 ") (writeln (format-sexp (format-program program-1)))
  (assert-equal result value))

(test-program
 '(program
   ()
   (let ((x 4))
     (- 8 x)))
 4)

(test-program
 '(program
   ()
   (let ((x 32))
     (+ (let ((x 10))
          x)
        x)))
 42)

(test-program
 '(program
   ()
   (let ((x (let ((x 4))
              (+ x 1))))
     (+ x 2)))
 7)

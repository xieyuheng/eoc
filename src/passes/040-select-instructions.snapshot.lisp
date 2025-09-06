(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program predicate sexp)
  (= program-0 (check-program (parse-program sexp)))
  (= program-1 (check-program (uniquify program-0)))
  (= program-2 (check-program (rco-program program-1)))
  (= c-program-3 (check-c-program (explicate-control program-2)))
  (= x86-program-4 (select-instructions c-program-3))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (write "030 ") (writeln (format-sexp (form-c-program c-program-3)))
  (write "040 ") (writeln (format-sexp (form-x86-program x86-program-4)))
  (assert-the predicate (eval-program program-2))
  (assert-the predicate (eval-c-program c-program-3)))

(test-program
 (equal? 42)
 '(program
   ()
   (let ((y (let ((x 20))
              (iadd x (let ((x 22))
                        x)))))
     y)))

(test-program
 (equal? 42)
 '(program
   ()
   (let ((y (let ((x 20))
              (let ((z 22))
                (iadd x z)))))
     y)))

(test-program
 (equal? 6)
 '(program
   ()
   (let ((z (let ((y (let ((x 6))
                       x)))
              y)))
     z)))

(test-program
 (equal? 42)
 '(program
   ()
   (let ((a 42))
     (let ((b a))
       b))))

(test-program
 int?
 '(program
   ()
   (ineg (random-dice))))

(test-program
 int?
 '(program
   ()
   (iadd (random-dice) (random-dice))))

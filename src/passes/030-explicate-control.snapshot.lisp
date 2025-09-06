(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program expected sexp)
  (= program-0 (check-program (parse-program sexp)))
  (= program-1 (check-program (uniquify program-0)))
  (= program-2 (check-program (rco-program program-1)))
  (= c-program-3 (check-c-program (explicate-control program-2)))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (write "030 ") (writeln (format-sexp (form-c-program c-program-3)))
  (assert-equal expected (eval-program program-2))
  (assert-equal expected (eval-c-program c-program-3)))

(test-program
 42
 '(program
   ()
   42))

(test-program
 42
 '(program
   ()
   (iadd 20 22)))

(test-program
 42
 '(program
   ()
   (iadd 20 (iadd 11 11))))

(test-program
 42
 '(program
   ()
   (let ((y (let ((x 20))
              (iadd x (let ((x 22))
                        x)))))
     y)))

(test-program
 42
 '(program
   ()
   (let ((y (let ((x 20))
              (let ((z 22))
                (iadd x z)))))
     y)))

(test-program
 6
 '(program
   ()
   (let ((z (let ((y (let ((x 6))
                       x)))
              y)))
     z)))

(test-program
 15
 '(program
   ()
   (let ((x (iadd (iadd 1 2) (iadd 3 4))))
     (iadd x 5))))

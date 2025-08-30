(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program expected sexp)
  (= program-0 (parse-program sexp))
  (= program-1 (uniquify program-0))
  (= program-2 (rco-program program-1))
  (= result (eval-program program-2))
  (= c-program-3 (explicate-control program-2))
  (= c-result (eval-c-program c-program-3))
  (= x86-program-4 (select-instructions c-program-3))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (write "030 ") (writeln (format-sexp (form-c-program c-program-3)))
  (write "040 ") (writeln (format-sexp (form-x86-program x86-program-4)))
  (assert-equal expected result)
  (assert-equal expected c-result))

(test-program
 42
 '(program
   ()
   (let ((y (let ((x 20))
              (+ x (let ((x 22))
                     x)))))
     y)))

(test-program
 42
 '(program
   ()
   (let ((y (let ((x 20))
              (let ((z 22))
                (+ x z)))))
     y)))

(test-program
 6
 '(program
   ()
   (let ((z (let ((y (let ((x 6))
                       x)))
              y)))
     z)))

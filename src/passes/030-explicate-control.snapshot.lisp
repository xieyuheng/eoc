(import-all "deps.lisp")
(import-all "010-uniquify.lisp")
(import-all "020-remove-complex-operands.lisp")
(import-all "030-explicate-control.lisp")

(define (test-program expected program-sexp)
  (= program-0 (parse-program program-sexp))
  (= program-1 (uniquify program-0))
  (= program-2 (rco-program program-1))
  (= result (eval-program program-2))
  (= c-program-3 (explicate-control program-2))
  (= c-result (c/eval-c-program c-program-3))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (write "030 ") (writeln (format-sexp (c/form-c-program c-program-3)))
  (assert-equal expected result)
  (assert-equal expected c-result))

(test-program
 42
 '(program
   ()
   42))

(test-program
 42
 '(program
   ()
   (+ 20 22)))

(test-program
 42
 '(program
   ()
   (+ 20 (+ 11 11))))

(test-program
 42
 '(program
   ()
   (let ((y (let ((x 20))
              (+ x (let ((x 22))
                     x)))))
     y)) )

(test-program
 42
 '(program
   ()
   (let ((y (let ((x.1 20))
              (let ((x.2 22))
                (+ x.1 x.2)))))
     y)) )

(test-program
 6
 '(program
   ()
   (let ((z (let ((y (let ((x 6))
                       x)))
              y)))
     z)) )

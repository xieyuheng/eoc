(import-all "deps.lisp")
(import-all "010-uniquify.lisp")
(import-all "020-remove-complex-operands.lisp")

(define (test-program expected program-sexp)
  (= program-0 (parse-program program-sexp))
  (= program-1 (uniquify program-0))
  (= program-2 (rco-program program-1))
  (= result (eval-program program-2))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (assert-equal expected result))

(test-program
 42
 '(program
   ()
   (let ((x (+ 42 (- 10))))
     (+ x 10))))

(test-program
 15
 '(program
   ()
   (+ (+ 1 2) (+ 3 (+ 4 5)))))

(test-program
 42
 '(program
   ()
   (let ((a 42))
     (let ((b a))
       b))))

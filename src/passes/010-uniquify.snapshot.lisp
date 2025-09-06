(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program expected sexp)
  (= program-0 (check-program (parse-program sexp)))
  (= program-1 (check-program (uniquify program-0)))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (assert-equal expected (eval-program program-1)))

(test-program
 4
 '(program
   ()
   (let ((x 4))
     (isub 8 x))))

(test-program
 42
 '(program
   ()
   (let ((x 32))
     (iadd (let ((x 10))
             x)
           x))))

(test-program
 7
 '(program
   ()
   (let ((x (let ((x 4))
              (iadd x 1))))
     (iadd x 2))))

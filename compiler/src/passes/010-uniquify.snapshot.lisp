(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program predicate sexp)
  (= program-0 (check-program (parse-program sexp)))
  (= program-1 (check-program (uniquify program-0)))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (assert-the predicate (eval-program program-1)))

(test-program
 (equal? 12)
 '(program
   ()
   (let ((x 4))
     (iadd 8 x))))

(test-program
 (equal? 42)
 '(program
   ()
   (let ((x 32))
     (iadd (let ((x 10))
             x)
           x))))

(test-program
 (equal? 7)
 '(program
   ()
   (let ((x (let ((x 4))
              (iadd x 1))))
     (iadd x 2))))

(import-all "deps.lisp")
(import-all "index.lisp")

(define (test-program expected sexp)
  (= program-0 (check-program (parse-program sexp)))
  (= program-1 (check-program (uniquify program-0)))
  (= program-2 (check-program (rco-program program-1)))
  (write "000 ") (writeln (format-sexp (form-program program-0)))
  (write "010 ") (writeln (format-sexp (form-program program-1)))
  (write "020 ") (writeln (format-sexp (form-program program-2)))
  (assert-equal expected (eval-program program-2)))

(test-program
 42
 '(program
   ()
   (let ((x (iadd 42 (ineg 10))))
     (iadd x 10))))

(test-program
 10
 '(program
   ()
   (iadd (iadd 1 2) (iadd 3 4))))

(test-program
 15
 '(program
   ()
   (iadd (iadd 1 2) (iadd 3 (iadd 4 5)))))

(test-program
 42
 '(program
   ()
   (let ((a 42))
     (let ((b a))
       b))))

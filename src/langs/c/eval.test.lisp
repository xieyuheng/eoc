(import-all "index.lisp")

(define (test-program expected sexp)
  (= program (parse-program sexp))
  (= value (eval-program program))
  (assert-equal expected value))

(test-program
 1
 '(program
   ()
   ((start
     (return 1)))))

(test-program
 1
 '(program
   ()
   ((start
     (= x 1)
     (return x)))))

(test-program
 3
 '(program
   ()
   ((start
     (return (+ 1 2))))))

(test-program
 3
 '(program
   ()
   ((start
     (= x (+ 1 2))
     (return x)))))

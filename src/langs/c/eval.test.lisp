(import-all "index.lisp")

(define (test-c-program predicate sexp)
  (= c-program (parse-c-program sexp))
  (= value (eval-c-program c-program))
  (assert-the predicate value))

(test-c-program
 (equal? 1)
 '(c-program
   ()
   (:start
    ((return 1)))))

(test-c-program
 (equal? 1)
 '(c-program
   ()
   (:start
    ((= x 1)
     (return x)))))

(test-c-program
 (equal? 3)
 '(c-program
   ()
   (:start
    ((return (iadd 1 2))))))

(test-c-program
 (equal? 3)
 '(c-program
   ()
   (:start
    ((= x (iadd 1 2))
     (return x)))))
